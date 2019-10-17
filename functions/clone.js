const crypto = require('crypto');
const { execSync } = require('child_process');
const AWS = require('aws-sdk');
const fs = require('fs');

/**
 * Clone and zip a git repo.
 * @param {object} repository
 *   The repository details.
 */
const cloneAndZip = ({ name, clone_url }) => {
  const tmpDir = '/tmp';
  const zipName = process.env.ZIP_NAME;
  const execOpts = {
    encoding: 'utf8',
    stdio: 'inherit',
  };

  execSync(`rm -rf ${tmpDir}/*`, execOpts);

  execSync(`cd ${tmpDir} && git clone --depth 1 ${clone_url}`, execOpts);

  execSync(`cd ${tmpDir} && tar -zcvf ${zipName} ${name}`);

  return `${tmpDir}/${zipName}`;
};

/**
 * Upload the zip to S3.
 */
const uploadToS3 = async (zipPath) => {
  const s3 = new AWS.S3({
    apiVersion: '2006-03-01',
  });
  const params = {
    Bucket: process.env.S3_BUCKET,
    Key: process.env.ZIP_NAME,
    Body: fs.createReadStream(zipPath),
  };

  await s3.upload(params).promise();
};

/**
 * Validate a GitHub hash signature.
 *
 * https://developer.github.com/webhooks/securing/
 */
const validateSignature = (payload, xHubSignature) => {
  const hmac = crypto.createHmac('sha1', process.env.GITHUB_WEBHOOK_SECRET);
  const hex = hmac.update(payload, 'utf-8').digest('hex');
  const sig = `sha1=${hex}`;

  const bufferA = Buffer.from(sig, 'utf8');
  const bufferB = Buffer.from(xHubSignature, 'utf8');

  return crypto.timingSafeEqual(bufferA, bufferB);
}

/**
 * Get the Lambda proxy output.
 *
 * https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
 */
const getResponse = ({
  statusCode = 500,
  headers = {},
  body = '',
  isBase64Encoded = false,
}) => {
  return {
    isBase64Encoded,
    statusCode,
    headers,
    body,
  };
}

/**
 * Run.
 */
exports.handler = async (event) => {
  const { headers, body } = event;
  const { repository } = JSON.parse(body);

  if (
    !headers
    || headers['User-Agent'].indexOf('GitHub-Hookshot') < 0
    || !validateSignature(body, headers['X-Hub-Signature'])
  ) {
    return getResponse({
      statusCode: 403,
      body: 'Invalid token',
    });
  }

  const zipPath = cloneAndZip(repository);

  await uploadToS3(zipPath);

  return {
    statusCode: 200
  };
}
