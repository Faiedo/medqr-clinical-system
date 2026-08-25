const test = require('node:test');
const assert = require('node:assert');
const { validateClinicalRecord } = require('../src/index.js');

test('Validacao de ficha clinica completa e valida', (t) => {
  const validRecord = {
    nome: 'Carlos',
    sobrenome: 'Silva',
    sexo: 'Masculino',
    contato_emergencia: '(11) 98765-4321 - Esposa (Maria)',
    tipo_sanguineo: 'O+',
    alergias: 'Penicilina',
    medicamentos: 'Losartana 50mg',
    doencas: 'Hipertensao',
    cirurgias: 'Apendicectomia (2018)'
  };

  const result = validateClinicalRecord(validRecord);
  assert.strictEqual(result.valid, true);
  assert.ok(result.token.startsWith('medqr_'));
});

test('Rejeicao de ficha clinica sem campo obrigatorio', (t) => {
  const invalidRecord = {
    nome: 'Carlos',
    sobrenome: 'Silva',
    sexo: 'Masculino',
    contato_emergencia: '',
    tipo_sanguineo: 'O+'
  };

  assert.throws(() => {
    validateClinicalRecord(invalidRecord);
  }, /Campo obrigatorio ausente/);
});

test('Rejeicao de tipo sanguineo invalido', (t) => {
  const invalidBloodRecord = {
    nome: 'Carlos',
    sobrenome: 'Silva',
    sexo: 'Masculino',
    contato_emergencia: '(11) 98765-4321',
    tipo_sanguineo: 'XYZ'
  };

  assert.throws(() => {
    validateClinicalRecord(invalidBloodRecord);
  }, /Tipo sanguineo invalido/);
});
