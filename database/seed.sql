-- Seed Initial Core Categories
INSERT INTO categories (id, name, slug, description) VALUES
(1, 'Attachment & Careers', 'careers', 'Industrial attachments, internships, CV guides, and interview preparation resources.'),
(2, 'ICT & Digital Skills', 'ict', 'Digital skills guides, cybersecurity policies, AI tools, and cloud computing frameworks.'),
(3, 'Transport & Fleet Safety', 'transport', 'Logistics, supply chain guides, road safety manuals, and defensive driving modules.'),
(4, 'Corporate & Awards', 'awards', 'East Africa Transport Awards brochures, company profile, and feedback forms.');

-- Keep the sequence in sync since we inserted explicit IDs above
SELECT setval('categories_id_seq', (SELECT MAX(id) FROM categories));

-- Seed Initial Sub-Categories
INSERT INTO sub_categories (category_id, name, slug, description) VALUES
(1, 'Attachment Guides', 'attachment-guides', 'Application forms and attachment manuals'),
(1, 'Career Development', 'career-dev', 'CV templates and interview preparation guides'),
(2, 'ICT Infrastructure', 'ict-infrastructure', 'Network and cybersecurity documentation'),
(3, 'Road Safety Guides', 'road-safety', 'Road safety club and fleet management manuals'),
(4, 'Awards Brochures', 'awards-brochures', 'Annual award ceremony catalogs and application forms');

-- A handful of sample resources so Devs 4/5 have real data to build the
-- listing page and search against before Devs 7-10 finish content population.
INSERT INTO resources (sub_category_id, title, description, file_url, is_featured) VALUES
(1, 'Industrial Attachment Application Form 2026', 'Official application form for students seeking an industrial attachment placement.', 'https://storage.mfanoboraafrica.com/docs/attachment-application-form.pdf', TRUE),
(2, 'CV Writing Guide for Students', 'Step-by-step guide to writing a professional, attachment-ready CV.', 'https://storage.mfanoboraafrica.com/docs/cv-writing-guide.pdf', TRUE),
(3, 'Cybersecurity Basics for Beginners', 'An introductory guide to cybersecurity concepts and safe digital practices.', 'https://storage.mfanoboraafrica.com/docs/cybersecurity-basics.pdf', FALSE),
(4, 'Defensive Driving Manual', 'Fleet and road safety manual covering defensive driving techniques.', 'https://storage.mfanoboraafrica.com/docs/defensive-driving-manual.pdf', TRUE),
(5, '4th East Africa Transport Awards Brochure', 'Official brochure for the 4th East Africa Transport Awards gala.', 'https://storage.mfanoboraafrica.com/docs/transport-awards-brochure.pdf', FALSE);
