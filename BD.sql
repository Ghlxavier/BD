SET FOREIGN_KEY_CHECKS = 0;
DROP DATABASE IF EXISTS escola_db;
CREATE DATABASE escola_db;
USE escola_db;
SET FOREIGN_KEY_CHECKS = 1;

-- Tabela pessoa
CREATE TABLE pessoa (
  pessoa_id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  cpf VARCHAR(14) UNIQUE,
  data_nascimento DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Aluno
CREATE TABLE aluno (
  aluno_id INT PRIMARY KEY,
  ra VARCHAR(20) NOT NULL UNIQUE,
  telefone VARCHAR(20),
  endereco VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (aluno_id) REFERENCES pessoa(pessoa_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Professor
CREATE TABLE professor (
  professor_id INT PRIMARY KEY,
  especialidade VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (professor_id) REFERENCES pessoa(pessoa_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Responsavel
CREATE TABLE responsavel (
  responsavel_id INT PRIMARY KEY,
  telefone VARCHAR(20),
  parentesco VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (responsavel_id) REFERENCES pessoa(pessoa_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Curso
CREATE TABLE curso (
  curso_id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  carga_horaria INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Disciplina
CREATE TABLE disciplina (
  disciplina_id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  carga_horaria INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Turma
CREATE TABLE turma (
  turma_id INT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(30) NOT NULL UNIQUE,
  ano YEAR NOT NULL,
  semestre TINYINT NOT NULL,
  turno ENUM('Manha','Tarde','Noite') NOT NULL,
  curso_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (curso_id) REFERENCES curso(curso_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Matricula
CREATE TABLE matricula (
  matricula_id INT AUTO_INCREMENT PRIMARY KEY,
  aluno_id INT NOT NULL,
  turma_id INT NOT NULL,
  data_matricula DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (aluno_id) REFERENCES aluno(aluno_id) ON DELETE CASCADE,
  FOREIGN KEY (turma_id) REFERENCES turma(turma_id) ON DELETE CASCADE,
  UNIQUE (aluno_id, turma_id, data_matricula)
) ENGINE=InnoDB;

-- Nota
CREATE TABLE nota (
  nota_id INT AUTO_INCREMENT PRIMARY KEY,
  matricula_id INT NOT NULL,
  disciplina_id INT NOT NULL,
  nota_valor DECIMAL(5,2),
  frequencia_percent DECIMAL(5,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (matricula_id) REFERENCES matricula(matricula_id) ON DELETE CASCADE,
  FOREIGN KEY (disciplina_id) REFERENCES disciplina(disciplina_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Leciona
CREATE TABLE leciona (
  leciona_id INT AUTO_INCREMENT PRIMARY KEY,
  professor_id INT NOT NULL,
  disciplina_id INT NOT NULL,
  turma_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (professor_id) REFERENCES professor(professor_id) ON DELETE CASCADE,
  FOREIGN KEY (disciplina_id) REFERENCES disciplina(disciplina_id) ON DELETE CASCADE,
  FOREIGN KEY (turma_id) REFERENCES turma(turma_id) ON DELETE SET NULL,
  UNIQUE (professor_id, disciplina_id, turma_id)
) ENGINE=InnoDB;

-- Curso_Disciplina
CREATE TABLE curso_disciplina (
  curso_disciplina_id INT AUTO_INCREMENT PRIMARY KEY,
  curso_id INT NOT NULL,
  disciplina_id INT NOT NULL,
  semestre_sugerido TINYINT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (curso_id) REFERENCES curso(curso_id) ON DELETE CASCADE,
  FOREIGN KEY (disciplina_id) REFERENCES disciplina(disciplina_id) ON DELETE CASCADE,
  UNIQUE (curso_id, disciplina_id)
) ENGINE=InnoDB;

-- Responsavel_Aluno
CREATE TABLE responsavel_aluno (
  id INT AUTO_INCREMENT PRIMARY KEY,
  responsavel_id INT NOT NULL,
  aluno_id INT NOT NULL,
  principal BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (responsavel_id) REFERENCES responsavel(responsavel_id) ON DELETE CASCADE,
  FOREIGN KEY (aluno_id) REFERENCES aluno(aluno_id) ON DELETE CASCADE,
  UNIQUE (responsavel_id, aluno_id)
) ENGINE=InnoDB;

-- INSERINDO DADOs
USE escola_db;
INSERT INTO pessoa (nome, cpf, data_nascimento) VALUES
('Ana Silva','123.456.789-00','2006-05-12'),
('Pedro Souza','987.654.321-00','2005-02-20'),
('Mariana Costa','111.222.333-44','1980-10-04'),
('Carlos Pereira','222.333.444-55','1975-01-30'),
('Luiza Gomes','333.444.555-66','1990-07-18');

INSERT INTO aluno (aluno_id, ra, telefone, endereco)
VALUES
(1,'RA2025001','(11)99999-0001','Rua A, 100'),
(2,'RA2025002','(11)99999-0002','Rua B, 200');

INSERT INTO professor (professor_id, especialidade)
VALUES
(3,'Matemática'),
(4,'Língua Portuguesa');

INSERT INTO responsavel (responsavel_id, telefone, parentesco)
VALUES
(5,'(11)98888-0001','Mãe');

INSERT INTO curso (nome, carga_horaria)
VALUES
('Ensino Médio', 2000),
('Técnico em Informática', 1600);

INSERT INTO disciplina (nome, carga_horaria)
VALUES
('Matemática', 120),
('Português', 100),
('Programação', 160);

INSERT INTO turma (codigo, ano, semestre, turno, curso_id)
VALUES
('EM2025A',2025,1,'Manha',1),
('TI2025A',2025,1,'Tarde',2);

INSERT INTO matricula (aluno_id, turma_id, data_matricula)
VALUES
(1,1,'2025-02-15'),
(2,2,'2025-02-16');

INSERT INTO nota (matricula_id, disciplina_id, nota_valor, frequencia_percent)
VALUES
(1,1,8.5,95.00),
(1,2,7.0,92.50),
(2,3,9.0,98.00);

INSERT INTO leciona (professor_id, disciplina_id, turma_id)
VALUES
(3,1,1),
(4,2,1),
(3,3,2);

INSERT INTO curso_disciplina (curso_id, disciplina_id, semestre_sugerido)
VALUES
(1,1,1),
(1,2,1),
(2,3,1);

INSERT INTO responsavel_aluno (responsavel_id, aluno_id, principal)
VALUES
(5,1,TRUE);

-- CONSULTAS
SELECT p.nome AS aluno_nome, a.ra, t.codigo AS turma, c.nome AS curso
FROM aluno a
JOIN pessoa p ON a.aluno_id = p.pessoa_id
JOIN matricula m ON m.aluno_id = a.aluno_id
JOIN turma t ON t.turma_id = m.turma_id
JOIN curso c ON c.curso_id = t.curso_id;

SELECT p.nome AS aluno, d.nome AS disciplina, n.nota_valor
FROM nota n
JOIN matricula m ON n.matricula_id = m.matricula_id
JOIN aluno a ON m.aluno_id = a.aluno_id
JOIN pessoa p ON a.aluno_id = p.pessoa_id
JOIN disciplina d ON n.disciplina_id = d.disciplina_id;

SELECT pe.nome AS professor, d.nome AS disciplina, t.codigo AS turma
FROM leciona l
JOIN professor pr ON l.professor_id = pr.professor_id
JOIN pessoa pe ON pr.professor_id = pe.pessoa_id
JOIN disciplina d ON l.disciplina_id = d.disciplina_id
LEFT JOIN turma t ON l.turma_id = t.turma_id
WHERE t.codigo = 'EM2025A';

SELECT al.nome AS aluno, rp.nome AS responsavel, ra.parentesco
FROM responsavel_aluno ra
JOIN responsavel r ON ra.responsavel_id = r.responsavel_id
JOIN pessoa rp ON r.responsavel_id = rp.pessoa_id
JOIN aluno a ON ra.aluno_id = a.aluno_id
JOIN pessoa al ON a.aluno_id = al.pessoa_id
WHERE al.ra = 'RA2025001';

-- UPDATES
UPDATE nota
SET nota_valor = 8.8
WHERE nota_id = 1;

UPDATE responsavel
SET telefone = '(11)99999-1234'
WHERE responsavel_id = 5;
