const http = require('http');

// MedQR Core Module - Clinical Information Verification
function validateClinicalRecord(record) {
  const requiredFields = [
    'nome',
    'sobrenome',
    'sexo',
    'contato_emergencia',
    'tipo_sanguineo'
  ];

  for (const field of requiredFields) {
    if (!record[field] || record[field].toString().trim() === '') {
      throw new Error(`Campo obrigatorio ausente: ${field}`);
    }
  }

  const validBloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  if (!validBloodTypes.includes(record.tipo_sanguineo.toUpperCase())) {
    throw new Error(`Tipo sanguineo invalido: ${record.tipo_sanguineo}`);
  }

  return {
    valid: true,
    token: `medqr_${Buffer.from(record.nome + Date.now()).toString('base64').substring(0, 12)}`
  };
}

// HTTP Server for Container Execution and Healthchecks
function createServer(port = process.env.PORT || 3000) {
  const server = http.createServer((req, res) => {
    // CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
      res.writeHead(204);
      res.end();
      return;
    }

    if (req.url === '/health' && req.method === 'GET') {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({
        status: 'UP',
        service: 'medqr-clinical-system',
        uptime: process.uptime(),
        environment: process.env.NODE_ENV || 'production',
        timestamp: new Date().toISOString()
      }));
      return;
    }

    if (req.url === '/' && req.method === 'GET') {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({
        project: 'MedQR - Sistema para Compartilhamento de Informações Clínicas',
        version: '2.0.0',
        phase: 'Fase 2 - Entrega Contínua e Orquestração',
        endpoints: {
          health: 'GET /health',
          validate: 'POST /api/records/validate'
        }
      }));
      return;
    }

    if (req.url === '/api/records/validate' && req.method === 'POST') {
      let body = '';
      req.on('data', chunk => { body += chunk; });
      req.on('end', () => {
        try {
          const payload = JSON.parse(body || '{}');
          const result = validateClinicalRecord(payload);
          res.writeHead(200, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify(result));
        } catch (err) {
          res.writeHead(400, { 'Content-Type': 'application/json' });
          res.end(JSON.stringify({ error: err.message }));
        }
      });
      return;
    }

    res.writeHead(404, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ error: 'Endpoint nao encontrado' }));
  });

  return server;
}

if (require.main === module) {
  const PORT = process.env.PORT || 3000;
  const server = createServer(PORT);
  server.listen(PORT, '0.0.0.0', () => {
    console.log(`[MedQR App] Servidor operacional na porta ${PORT}`);
    console.log(`[MedQR App] Healthcheck disponivel em http://localhost:${PORT}/health`);
  });
}

module.exports = {
  validateClinicalRecord,
  createServer
};
