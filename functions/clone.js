const { execSync } = require('child_process');
const AWS = require('aws-sdk');
const fs = require('fs');

/**
 * Clone and zip a git repo.
 * @param {object} repository
 *   The repository details.
 */
const cloneAndZip = ({ name, url }) => {
  const tmpDir = '/tmp';
  const zipName = process.env.ZIP_NAME;
  const execOpts = {
    encoding: 'utf8',
    stdio: 'inherit',
  };

  execSync(`rm -rf ${tmpDir}/*`, execOpts);

  execSync(`cd ${tmpDir} && git clone --depth 1 ${url}`, execOpts);

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
 * Get the GutHub webhook hash signature.
 *
 * https://developer.github.com/webhooks/securing/
 */
const getSignature = () => {
  const hmac = crypto.createHmac('sha1', process.env.GITHUB_WEBHOOK_SECRET);
  const hex = hmac.update(chunk.toString()).digest('hex');

  return `sha1=${hex}`;
}

/**
 * Get the Lambda proxy output.
 *
 * https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html
 */
const getJsonResponse = ({
  statusCode = 200,
  headers = {},
  body = '',
  isBase64Encoded = false,
}) => {
  return JSON.stringify({
    isBase64Encoded,
    statusCode,
    headers,
    body,
  });
}

/**
 * Run.
 */
exports.handler = async (event, context, callback) => {
  const { headers } = event;
  const { repository } = context;

  if (headers['X-Hub-Signature'] !== getSignature()) {
    callback(getJsonResponse(403));
  }

  const zipPath = cloneAndZip(repository);

  await uploadToS3(zipPath);

  callback(getJsonResponse(200))
}
