const express = require('express');
const cors = require('cors');
const Database = require('better-sqlite3');

const db = new Database('agrismart.db');
db.exec(`
  CREATE TABLE IF NOT EXISTS maladies (
    id TEXT PRIMARY KEY,
    nom TEXT NOT NULL,
    plante TEXT NOT NULL,
    symptomes TEXT DEFAULT '',
    traitement TEXT DEFAULT '',
    gravite TEXT DEFAULT 'moyenne',
    date TEXT NOT NULL
  )
`);

const app = express();
app.use(cors());
app.use(express.json());

function lire(body, id) {
  return {
    id: id ?? body.id,
    nom: body.nom,
    plante: body.plante,
    symptomes: body.symptomes ?? '',
    traitement: body.traitement ?? '',
    gravite: body.gravite ?? 'moyenne',
    date: body.date,
  };
}

// Lister
app.get('/maladies', (req, res) => {
  const rows = db.prepare('SELECT * FROM maladies ORDER BY date DESC').all();
  res.json(rows);
});

// Ajouter
app.post('/maladies', (req, res) => {
  const m = lire(req.body);
  if (!m.id || !m.nom || !m.plante || !m.date) {
    return res.status(400).json({ erreur: 'Champs obligatoires manquants' });
  }
  db.prepare(
    `INSERT INTO maladies (id, nom, plante, symptomes, traitement, gravite, date)
     VALUES (@id, @nom, @plante, @symptomes, @traitement, @gravite, @date)`
  ).run(m);
  res.status(201).json(m);
});

// Modifier
app.put('/maladies/:id', (req, res) => {
  const m = lire(req.body, req.params.id);
  const r = db.prepare(
    `UPDATE maladies SET nom=@nom, plante=@plante, symptomes=@symptomes,
     traitement=@traitement, gravite=@gravite, date=@date WHERE id=@id`
  ).run(m);
  if (r.changes === 0) return res.status(404).json({ erreur: 'Introuvable' });
  res.json(m);
});

// Supprimer
app.delete('/maladies/:id', (req, res) => {
  db.prepare('DELETE FROM maladies WHERE id = ?').run(req.params.id);
  res.status(204).end();
});

app.listen(3000, '0.0.0.0', () => console.log('API sur http://localhost:3000'));