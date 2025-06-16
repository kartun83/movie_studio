const cds = require('@sap/cds');

module.exports = {
  getDbKind: () => cds.env.requires.db.kind,
  getTransaction: (req) => cds.transaction(req),
  SELECT: cds.ql.SELECT,
  UPDATE: cds.ql.UPDATE,
  INSERT: cds.ql.INSERT
}; 