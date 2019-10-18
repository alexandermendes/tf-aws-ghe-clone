const http = require('http');

/**
 * Get GitHub basic auth string.
 */
const getBasicAuth = () => {
  const user = process.env.GITHUB_USERNAME.trim();
  const pass = process.env.GITHUB_TOKEN.trim();
  const auth = Buffer.from(`${user}:${pass}`).toString('base64');

  return `Basic ${auth}`;
};

/**
 * Make an HTTP request.
 */
const request = (opts, data) => {
  return new Promise((resolve, reject) => {
    const options = {
      host: process.env.GITHUB_API_URL
        .replace(/^https?:\/\//, '')
        .replace(/\/$/, ''),
      headers: {
        'Content-Type': 'application/json',
        Authorization: getBasicAuth(),
      },
      ...opts,
    };

    const req = http.request(options, resolve);

    req.on('error', reject);
    req.write(JSON.stringify(data));
    req.end();
  });
};

/**
 * Create a webhook.
 */
const createWebhook = (owner, repo) => {
  const options = {
    path: `repos/${owner}/${repo}/hooks`,
    method: 'POST',
  };

  const data = {
    name: 'web',
    events: ['push'],
    active: true,
    config: {
      content_type: 'json',
      url: process.env.WEBHOOK_URL,
      secret: process.env.WEBHOOK_SECRET,
    },
  };

  return request(options, data)
};

/**
 * Run.
 */
exports.handler = async () => {
  const repositories = JSON.parse(process.env.REPOSITORIES);
  const promises = repositories.map(repo => createWebhook(repo.owner, repo.name));

  await Promise.all(promises);
}
