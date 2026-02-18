module.exports = {
  apps: [
    {
      name: "quasar-spa",
      script: "deploy.js",
      watch: false,
      autorestart: true,
      max_restarts: 10,
      env: {
        PORT: 8081,
        NODE_ENV: "production",
      },
    },
  ],
};