-- Seed Initial Core Categories
INSERT INTO categories (id, name, slug, description) VALUES
(1, 'Attachment & Careers', 'careers', 'Industrial attachments, internships, CV guides, and interview preparation resources.'),
(2, 'ICT & Digital Skills', 'ict', 'Digital skills guides, cybersecurity policies, AI tools, and cloud computing frameworks.'),
(3, 'Transport & Fleet Safety', 'transport', 'Logistics, supply chain guides, road safety manuals, and defensive driving modules.'),
(4, 'Corporate & Awards', 'awards', 'East Africa Transport Awards brochures, company profile, and feedback forms.');

-- Seed Initial Sub-Categories
INSERT INTO sub_categories (category_id, name, slug, description) VALUES
(1, 'Attachment Guides', 'attachment-guides', 'Application forms and attachment manuals'),
(1, 'Career Development', 'career-dev', 'CV templates and interview preparation guides'),
(2, 'ICT Infrastructure', 'ict-infrastructure', 'Network and cybersecurity documentation'),
(3, 'Road Safety Guides', 'road-safety', 'Road safety club and fleet management manuals'),
(4, 'Awards Brochures', 'awards-brochures', 'Annual award ceremony catalogs and application forms');
