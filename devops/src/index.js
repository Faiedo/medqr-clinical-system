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

module.exports = {
  validateClinicalRecord
};
