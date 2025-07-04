const cds = require('@sap/cds');

module.exports = cds.server;

cds.on('bootstrap', app => {
  app.get('/admin/jwt', (req, res) => {
    res.json({ jwt: req.user && req.user._jwt ? req.user._jwt : null });
  });
}); 