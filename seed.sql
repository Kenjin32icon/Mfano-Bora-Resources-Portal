-- ============================================================================
-- Mfano Bora Resources Portal - Seed Data
-- Compatible with schema.sql
-- ============================================================================
--
-- IMPORTANT:
-- This seed follows the supplied schema exactly.
--
-- The schema provides:
--   categories
--   sub_categories
--   resources
--
-- The proposed inventory fields:
--   RESOURCE_CODE
--   RESOURCE_TYPE
--   LOCATION
--   FILE_PATH
--
-- do NOT exist in the current schema and are therefore not inserted.
--
-- Because resources.file_url is NOT NULL, every resource below receives
-- a non-null document URL.
--
-- ============================================================================


-- ============================================================================
-- 1. CATEGORIES
-- ============================================================================

INSERT INTO categories (id, name, slug, description)
VALUES
    (
        1,
        'Attachment & Careers',
        'careers',
        'Industrial attachments, internships, CV guides, and interview preparation resources.'
    ),
    (
        2,
        'ICT & Digital Skills',
        'ict',
        'Digital skills guides, cybersecurity policies, AI tools, and cloud computing frameworks.'
    ),
    (
        3,
        'Transport & Fleet Safety',
        'transport',
        'Logistics, supply chain guides, road safety manuals, and defensive driving modules.'
    ),
    (
        4,
        'Corporate & Awards',
        'awards',
        'East Africa Transport Awards brochures, company profile, and feedback forms.'
    )
ON CONFLICT (id) DO UPDATE
SET
    name = EXCLUDED.name,
    slug = EXCLUDED.slug,
    description = EXCLUDED.description;


-- Keep category sequence synchronized.
SELECT setval(
    'categories_id_seq',
    COALESCE((SELECT MAX(id) FROM categories), 1),
    true
);


-- ============================================================================
-- 2. CORE SUB-CATEGORIES
-- ============================================================================

INSERT INTO sub_categories
    (category_id, name, slug, description)
VALUES
    (
        1,
        'Attachment Guides',
        'attachment-guides',
        'Application forms and attachment manuals.'
    ),
    (
        1,
        'Career Development',
        'career-dev',
        'CV templates and interview preparation guides.'
    ),
    (
        2,
        'ICT Infrastructure',
        'ict-infrastructure',
        'Network and cybersecurity documentation.'
    ),
    (
        3,
        'Road Safety Guides',
        'road-safety',
        'Road safety club and fleet management manuals.'
    ),
    (
        4,
        'Awards Brochures',
        'awards-brochures',
        'Annual award ceremony catalogs and application forms.'
    )
ON CONFLICT (slug) DO UPDATE
SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description;


-- ============================================================================
-- 3. ICT INVENTORY SUB-CATEGORIES
-- ============================================================================
--
-- These represent the CATEGORY values from the proposed resource inventory.
-- They are stored correctly as sub_categories because the current schema
-- does not have a separate resource category column.
-- ============================================================================

INSERT INTO sub_categories
    (category_id, name, slug, description)
VALUES
    (2, 'Computer Hardware', 'computer-hardware',
     'Desktop computers, laptops, monitors, and related computer hardware.'),

    (2, 'Computer Accessories', 'computer-accessories',
     'Keyboards, mice, cables, connectors, and related computer accessories.'),

    (2, 'Office Equipment', 'office-equipment',
     'Printers, scanners, photocopiers, and related office equipment.'),

    (2, 'Presentation Equipment', 'presentation-equipment',
     'Projectors, projection screens, and interactive presentation equipment.'),

    (2, 'Networking', 'networking',
     'Network connectivity equipment and infrastructure.'),

    (2, 'Networking Tools', 'networking-tools',
     'Tools used to install, test, and maintain network infrastructure.'),

    (2, 'Server Equipment', 'server-equipment',
     'Servers, server racks, and associated server equipment.'),

    (2, 'Power Equipment', 'power-equipment',
     'UPS systems, power adapters, extension cables, and surge protection.'),

    (2, 'Storage Devices', 'storage-devices',
     'Hard drives, SSDs, flash drives, memory cards, and optical storage.'),

    (2, 'Software', 'software',
     'General operating systems and software resources.'),

    (2, 'Productivity Software', 'productivity-software',
     'Applications used for documents, spreadsheets, presentations, and productivity.'),

    (2, 'Database Software', 'database-software',
     'Applications used to create and manage databases.'),

    (2, 'Internet Software', 'internet-software',
     'Software used to access websites and online services.'),

    (2, 'Security Software', 'security-software',
     'Software used to protect computers against malware and security threats.'),

    (2, 'Utility Software', 'utility-software',
     'Utilities for file compression, backup, and system management.'),

    (2, 'Database', 'database',
     'Database management systems and database-related resources.'),

    (2, 'Web Development', 'web-development',
     'Tools and technologies used for web development.'),

    (2, 'Programming', 'programming',
     'Programming languages, code editors, and development environments.'),

    (2, 'Network Security', 'network-security',
     'Systems used to protect network infrastructure and traffic.'),

    (2, 'Cybersecurity', 'cybersecurity',
     'Tools and systems used to protect digital information and accounts.'),

    (2, 'ICT Management', 'ict-management',
     'Systems and resources used to manage ICT users, services, and operations.'),

    (2, 'Security', 'security',
     'Systems used to control access to restricted resources or areas.'),

    (2, 'Security Equipment', 'security-equipment',
     'CCTV, biometric, and related security equipment.'),

    (2, 'Network Management', 'network-management',
     'Tools used to monitor and manage network performance.'),

    (2, 'Communication', 'communication',
     'Electronic communication systems and services.'),

    (2, 'Internet Resources', 'internet-resources',
     'Internet connectivity and access resources.'),

    (2, 'Communication Equipment', 'communication-equipment',
     'Telephones, mobile devices, webcams, microphones, speakers, and headsets.'),

    (2, 'Multimedia Equipment', 'multimedia-equipment',
     'Digital cameras and other multimedia equipment.'),

    (2, 'Maintenance Tools', 'maintenance-tools',
     'Tools and equipment used for ICT maintenance and repair.'),

    (2, 'ICT Documents', 'ict-documents',
     'Policies, registers, manuals, logs, and other ICT documentation.'),

    (2, 'Network Documentation', 'network-documentation',
     'Network diagrams and related network documentation.'),

    (2, 'Data Management', 'data-management',
     'Database backups, digital records, and data resources.'),

    (2, 'Cloud Services', 'cloud-services',
     'Cloud storage and cloud backup services.'),

    (2, 'File Management', 'file-management',
     'Shared folders and other file management resources.'),

    (2, 'Records Management', 'records-management',
     'Systems used to organize and manage electronic records.'),

    (2, 'Management Systems', 'management-systems',
     'ICT-enabled organizational management systems.'),

    (2, 'Training Resources', 'training-resources',
     'ICT training materials and learning resources.')
ON CONFLICT (slug) DO UPDATE
SET
    category_id = EXCLUDED.category_id,
    name = EXCLUDED.name,
    description = EXCLUDED.description;


-- ============================================================================
-- 4. ORIGINAL PORTAL RESOURCES
-- ============================================================================
--
-- These are the five resources from the original seed.
-- file_url is populated because schema.sql declares it NOT NULL.
-- ============================================================================

INSERT INTO resources
(
    sub_category_id,
    title,
    description,
    file_url,
    is_featured,
    is_published
)
SELECT
    sc.id,
    v.title,
    v.description,
    v.file_url,
    v.is_featured,
    TRUE
FROM
(
    VALUES
    (
        'attachment-guides',
        'Industrial Attachment Application Form 2026',
        'Official application form for students seeking an industrial attachment placement.',
        'https://storage.mfanoboraafrica.com/docs/attachment-application-form.pdf',
        TRUE
    ),
    (
        'career-dev',
        'CV Writing Guide for Students',
        'Step-by-step guide to writing a professional, attachment-ready CV.',
        'https://storage.mfanoboraafrica.com/docs/cv-writing-guide.pdf',
        TRUE
    ),
    (
        'ict-infrastructure',
        'Cybersecurity Basics for Beginners',
        'An introductory guide to cybersecurity concepts and safe digital practices.',
        'https://storage.mfanoboraafrica.com/docs/cybersecurity-basics.pdf',
        FALSE
    ),
    (
        'road-safety',
        'Defensive Driving Manual',
        'Fleet and road safety manual covering defensive driving techniques.',
        'https://storage.mfanoboraafrica.com/docs/defensive-driving-manual.pdf',
        TRUE
    ),
    (
        'awards-brochures',
        '4th East Africa Transport Awards Brochure',
        'Official brochure for the 4th East Africa Transport Awards gala.',
        'https://storage.mfanoboraafrica.com/docs/transport-awards-brochure.pdf',
        FALSE
    )
) AS v(
    sub_category_slug,
    title,
    description,
    file_url,
    is_featured
)
JOIN sub_categories sc
    ON sc.slug = v.sub_category_slug
WHERE NOT EXISTS
(
    SELECT 1
    FROM resources r
    WHERE r.title = v.title
);


-- ============================================================================
-- 5. PROPOSED ICT RESOURCE INVENTORY
-- ============================================================================
--
-- The original proposal contained RESOURCE_CODE values RES001 - RES102.
-- Those codes cannot be stored because the supplied schema has no
-- resource_code column.
--
-- The original CATEGORY values are mapped to sub_categories.
--
-- RESOURCE_TYPE and LOCATION are intentionally not inserted because the
-- current schema has no corresponding columns.
--
-- file_url is populated with a deterministic document path for every item
-- because resources.file_url is NOT NULL.
--
-- These paths should point to the actual files once they are uploaded.
-- ============================================================================

INSERT INTO resources
(
    sub_category_id,
    title,
    description,
    file_url,
    is_featured,
    is_published
)
SELECT
    sc.id,
    v.title,
    v.description,
    v.file_url,
    FALSE,
    TRUE
FROM
(
    VALUES

    (
        'computer-hardware',
        'Desktop Computer',
        'Computer used for general office and ICT tasks.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res001-desktop-computer.pdf'
    ),
    (
        'computer-hardware',
        'Laptop Computer',
        'Portable computer used for office work and training.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res002-laptop-computer.pdf'
    ),
    (
        'computer-accessories',
        'Keyboard',
        'Input device used to enter text and commands.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res003-keyboard.pdf'
    ),
    (
        'computer-accessories',
        'Computer Mouse',
        'Pointing device used to control the computer cursor.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res004-computer-mouse.pdf'
    ),
    (
        'computer-hardware',
        'Monitor',
        'Display device used to show computer output.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res005-monitor.pdf'
    ),
    (
        'office-equipment',
        'Printer',
        'Device used to print documents on paper.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res006-printer.pdf'
    ),
    (
        'office-equipment',
        'Scanner',
        'Device used to convert physical documents into digital files.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res007-scanner.pdf'
    ),
    (
        'office-equipment',
        'Photocopier',
        'Machine used to make copies of documents.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res008-photocopier.pdf'
    ),
    (
        'presentation-equipment',
        'Projector',
        'Device used to display computer content on a large screen.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res009-projector.pdf'
    ),
    (
        'presentation-equipment',
        'Projector Screen',
        'Screen used for displaying projected presentations.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res010-projector-screen.pdf'
    ),
    (
        'networking',
        'Router',
        'Network device used to connect different networks.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res011-router.pdf'
    ),
    (
        'networking',
        'Network Switch',
        'Device used to connect multiple devices on a local network.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res012-network-switch.pdf'
    ),
    (
        'networking',
        'Ethernet Cable',
        'Cable used to connect computers and network devices.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res013-ethernet-cable.pdf'
    ),
    (
        'networking',
        'Network Patch Panel',
        'Device used to organize and manage network cable connections.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res014-network-patch-panel.pdf'
    ),
    (
        'networking',
        'Wireless Access Point',
        'Device that provides wireless network connectivity.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res015-wireless-access-point.pdf'
    ),
    (
        'networking',
        'Network Rack',
        'Cabinet used to house networking equipment.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res016-network-rack.pdf'
    ),
    (
        'networking',
        'RJ45 Connector',
        'Connector used with Ethernet network cables.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res017-rj45-connector.pdf'
    ),
    (
        'networking-tools',
        'Crimping Tool',
        'Tool used to attach RJ45 connectors to network cables.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res018-crimping-tool.pdf'
    ),
    (
        'networking-tools',
        'Cable Tester',
        'Device used to test network cable connections.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res019-cable-tester.pdf'
    ),
    (
        'networking',
        'Network Adapter',
        'Hardware that enables a computer to connect to a network.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res020-network-adapter.pdf'
    ),
    (
        'server-equipment',
        'Server Computer',
        'Computer that provides services and resources to other computers.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res021-server-computer.pdf'
    ),
    (
        'server-equipment',
        'Server Rack',
        'Rack used to securely install server equipment.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res022-server-rack.pdf'
    ),
    (
        'power-equipment',
        'UPS',
        'Backup power device that protects computers from power interruptions.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res023-ups.pdf'
    ),
    (
        'storage-devices',
        'External Hard Drive',
        'Portable device used for storing and backing up data.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res024-external-hard-drive.pdf'
    ),
    (
        'storage-devices',
        'Internal Hard Drive',
        'Storage device used to store computer operating systems and files.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res025-internal-hard-drive.pdf'
    ),
    (
        'storage-devices',
        'Solid State Drive',
        'Fast storage device used for storing digital data.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res026-solid-state-drive.pdf'
    ),
    (
        'storage-devices',
        'USB Flash Drive',
        'Portable device used to transfer and store files.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res027-usb-flash-drive.pdf'
    ),
    (
        'storage-devices',
        'Memory Card',
        'Small removable storage device for digital data.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res028-memory-card.pdf'
    ),
    (
        'storage-devices',
        'CD/DVD',
        'Optical media used for storing and transferring information.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res029-cd-dvd.pdf'
    ),
    (
        'computer-accessories',
        'Card Reader',
        'Device used to read data from memory cards.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res030-card-reader.pdf'
    ),
    (
        'software',
        'Windows Operating System',
        'Operating system used to manage computer hardware and software.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res031-windows-operating-system.pdf'
    ),
    (
        'productivity-software',
        'Microsoft Word',
        'Application used to create and edit documents.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res032-microsoft-word.pdf'
    ),
    (
        'productivity-software',
        'Microsoft Excel',
        'Spreadsheet application used for calculations and data management.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res033-microsoft-excel.pdf'
    ),
    (
        'productivity-software',
        'Microsoft PowerPoint',
        'Application used to create presentations.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res034-microsoft-powerpoint.pdf'
    ),
    (
        'database-software',
        'Microsoft Access',
        'Application used to create and manage databases.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res035-microsoft-access.pdf'
    ),
    (
        'internet-software',
        'Web Browser',
        'Software used to access websites and online services.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res036-web-browser.pdf'
    ),
    (
        'security-software',
        'Antivirus Software',
        'Software used to protect computers against malware.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res037-antivirus-software.pdf'
    ),
    (
        'productivity-software',
        'PDF Reader',
        'Software used to open and read PDF documents.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res038-pdf-reader.pdf'
    ),
    (
        'utility-software',
        'File Compression Software',
        'Software used to compress and extract files.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res039-file-compression-software.pdf'
    ),
    (
        'utility-software',
        'Backup Software',
        'Software used to create copies of important data.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res040-backup-software.pdf'
    ),
    (
        'database',
        'Database Management System',
        'Software used to create, store and manage databases.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res041-database-management-system.pdf'
    ),
    (
        'database',
        'MySQL',
        'Database management system used to store structured information.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res042-mysql.pdf'
    ),
    (
        'database',
        'phpMyAdmin',
        'Web-based tool used to manage MySQL databases.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res043-phpmyadmin.pdf'
    ),
    (
        'web-development',
        'Localhost Server',
        'Local development environment used for testing web applications.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res044-localhost-server.pdf'
    ),
    (
        'web-development',
        'HTML',
        'Markup language used to structure web pages.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res045-html.pdf'
    ),
    (
        'web-development',
        'CSS',
        'Language used to style and format web pages.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res046-css.pdf'
    ),
    (
        'programming',
        'JavaScript',
        'Programming language used to add functionality to web pages.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res047-javascript.pdf'
    ),
    (
        'programming',
        'PHP',
        'Server-side programming language used for web development.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res048-php.pdf'
    ),
    (
        'programming',
        'Code Editor',
        'Application used to write and edit computer code.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res049-code-editor.pdf'
    ),
    (
        'programming',
        'Integrated Development Environment',
        'Software environment used for developing applications.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res050-integrated-development-environment.pdf'
    ),
    (
        'network-security',
        'Firewall',
        'Security system used to control network traffic.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res051-firewall.pdf'
    ),
    (
        'cybersecurity',
        'Password Manager',
        'Software used to securely manage passwords.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res052-password-manager.pdf'
    ),
    (
        'ict-management',
        'User Account Management System',
        'System used to manage user accounts and permissions.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res053-user-account-management-system.pdf'
    ),
    (
        'security',
        'Access Control System',
        'System used to control access to restricted areas or resources.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res054-access-control-system.pdf'
    ),
    (
        'security-equipment',
        'CCTV Camera',
        'Camera used for monitoring and security purposes.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res055-cctv-camera.pdf'
    ),
    (
        'security-equipment',
        'CCTV Monitor',
        'Display used to view CCTV camera footage.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res056-cctv-monitor.pdf'
    ),
    (
        'security-equipment',
        'Biometric Scanner',
        'Device used to identify users using biometric information.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res057-biometric-scanner.pdf'
    ),
    (
        'network-management',
        'Network Monitoring Tool',
        'Software used to monitor network performance and availability.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res058-network-monitoring-tool.pdf'
    ),
    (
        'cybersecurity',
        'Log Management System',
        'System used to collect and review computer and network logs.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res059-log-management-system.pdf'
    ),
    (
        'cybersecurity',
        'Data Encryption Tool',
        'Tool used to protect information by encrypting data.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res060-data-encryption-tool.pdf'
    ),
    (
        'communication',
        'Email System',
        'System used to send and receive electronic messages.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res061-email-system.pdf'
    ),
    (
        'internet-resources',
        'Internet Connection',
        'Network service providing access to online resources.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res062-internet-connection.pdf'
    ),
    (
        'networking',
        'Wi-Fi Network',
        'Wireless network providing internet and local network access.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res063-wifi-network.pdf'
    ),
    (
        'communication',
        'Video Conferencing System',
        'System used for online meetings and communication.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res064-video-conferencing-system.pdf'
    ),
    (
        'communication-equipment',
        'Telephone',
        'Device used for voice communication.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res065-telephone.pdf'
    ),
    (
        'communication-equipment',
        'Mobile Phone',
        'Portable device used for communication and internet access.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res066-mobile-phone.pdf'
    ),
    (
        'communication-equipment',
        'Webcam',
        'Camera used for video communication and conferencing.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res067-webcam.pdf'
    ),
    (
        'communication-equipment',
        'Microphone',
        'Device used to capture audio.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res068-microphone.pdf'
    ),
    (
        'communication-equipment',
        'Computer Speakers',
        'Devices used to produce computer audio.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res069-computer-speakers.pdf'
    ),
    (
        'communication-equipment',
        'Headset',
        'Device combining headphones and microphone for communication.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res070-headset.pdf'
    ),
    (
        'multimedia-equipment',
        'Digital Camera',
        'Camera used to capture digital photographs and videos.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res071-digital-camera.pdf'
    ),
    (
        'presentation-equipment',
        'Interactive Whiteboard',
        'Digital board used for interactive presentations and teaching.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res072-interactive-whiteboard.pdf'
    ),
    (
        'computer-accessories',
        'HDMI Cable',
        'Cable used to transmit digital audio and video.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res073-hdmi-cable.pdf'
    ),
    (
        'computer-accessories',
        'VGA Cable',
        'Cable used to connect computers to display devices.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res074-vga-cable.pdf'
    ),
    (
        'computer-accessories',
        'USB Cable',
        'Cable used for connecting and transferring data between devices.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res075-usb-cable.pdf'
    ),
    (
        'power-equipment',
        'Power Extension Cable',
        'Cable used to provide power to multiple devices.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res076-power-extension-cable.pdf'
    ),
    (
        'power-equipment',
        'Power Adapter',
        'Device used to provide suitable electrical power to ICT equipment.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res077-power-adapter.pdf'
    ),
    (
        'power-equipment',
        'Surge Protector',
        'Device that protects equipment from electrical surges.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res078-surge-protector.pdf'
    ),
    (
        'maintenance-tools',
        'Computer Cleaning Kit',
        'Tools and materials used to clean ICT equipment.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res079-computer-cleaning-kit.pdf'
    ),
    (
        'maintenance-tools',
        'Screwdriver Set',
        'Tools used for assembling and repairing computer equipment.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res080-screwdriver-set.pdf'
    ),
    (
        'ict-documents',
        'ICT Inventory Register',
        'Document used to record ICT equipment and resources.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res081-ict-inventory-register.pdf'
    ),
    (
        'ict-documents',
        'Asset Register',
        'Record containing information about organizational assets.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res082-asset-register.pdf'
    ),
    (
        'ict-documents',
        'Computer Maintenance Log',
        'Record of computer maintenance activities.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res083-computer-maintenance-log.pdf'
    ),
    (
        'ict-documents',
        'Network Maintenance Log',
        'Record of network maintenance and repairs.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res084-network-maintenance-log.pdf'
    ),
    (
        'ict-documents',
        'User Manual',
        'Document containing instructions for using ICT equipment or software.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res085-user-manual.pdf'
    ),
    (
        'ict-documents',
        'ICT Policy Document',
        'Document containing rules and guidelines for ICT use.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res086-ict-policy-document.pdf'
    ),
    (
        'ict-documents',
        'Data Backup Policy',
        'Document describing procedures for backing up organizational data.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res087-data-backup-policy.pdf'
    ),
    (
        'ict-documents',
        'Information Security Policy',
        'Document describing information security requirements.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res088-information-security-policy.pdf'
    ),
    (
        'network-documentation',
        'Network Diagram',
        'Diagram showing network devices and their connections.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res089-network-diagram.pdf'
    ),
    (
        'ict-documents',
        'System Documentation',
        'Documentation describing ICT systems and their operation.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res090-system-documentation.pdf'
    ),
    (
        'data-management',
        'Database Backup',
        'Copy of database information stored for recovery purposes.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res091-database-backup.pdf'
    ),
    (
        'data-management',
        'Digital Records',
        'Electronic records stored and managed using computer systems.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res092-digital-records.pdf'
    ),
    (
        'cloud-services',
        'Cloud Storage',
        'Online storage used to save and access digital files.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res093-cloud-storage.pdf'
    ),
    (
        'cloud-services',
        'Cloud Backup',
        'Online backup service used to protect organizational data.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res094-cloud-backup.pdf'
    ),
    (
        'file-management',
        'Shared Network Folder',
        'Network location used for sharing files among authorized users.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res095-shared-network-folder.pdf'
    ),
    (
        'records-management',
        'Digital Filing System',
        'System used to organize and manage electronic documents.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res096-digital-filing-system.pdf'
    ),
    (
        'management-systems',
        'Electronic Attendance System',
        'System used to record attendance electronically.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res097-electronic-attendance-system.pdf'
    ),
    (
        'ict-management',
        'ICT Helpdesk System',
        'System used to record and manage technical support requests.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res098-ict-helpdesk-system.pdf'
    ),
    (
        'ict-management',
        'IT Service Register',
        'Record of ICT services provided by the organization.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res099-it-service-register.pdf'
    ),
    (
        'training-resources',
        'ICT Training Materials',
        'Materials used to train users on ICT systems and applications.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res100-ict-training-materials.pdf'
    ),
    (
        'ict-management',
        'Resource Management System',
        'System used to manage and track organizational resources.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res101-resource-management-system.pdf'
    ),
    (
        'database',
        'ICT Resource Database',
        'Database used to store and manage information about ICT resources.',
        'https://storage.mfanoboraafrica.com/docs/ict-resources/res102-ict-resource-database.pdf'
    )

) AS v(
    sub_category_slug,
    title,
    description,
    file_url
)
JOIN sub_categories sc
    ON sc.slug = v.sub_category_slug
WHERE NOT EXISTS
(
    SELECT 1
    FROM resources r
    WHERE r.title = v.title
);


-- ============================================================================
-- 6. RESOURCE SEQUENCE
-- ============================================================================

SELECT setval(
    'resources_id_seq',
    COALESCE((SELECT MAX(id) FROM resources), 1),
    true
);


-- ============================================================================
-- 7. VALIDATION
-- ============================================================================

-- Total resources
SELECT COUNT(*) AS total_resources
FROM resources;


-- Total categories
SELECT COUNT(*) AS total_categories
FROM categories;


-- Total sub-categories
SELECT COUNT(*) AS total_sub_categories
FROM sub_categories;


-- Published resources
SELECT COUNT(*) AS published_resources
FROM resources
WHERE is_published = TRUE;


-- Featured resources
SELECT COUNT(*) AS featured_resources
FROM resources
WHERE is_featured = TRUE;


-- Resources grouped by category
SELECT
    c.name AS category,
    COUNT(r.id) AS resource_count
FROM categories c
LEFT JOIN sub_categories sc
    ON sc.category_id = c.id
LEFT JOIN resources r
    ON r.sub_category_id = sc.id
GROUP BY c.id, c.name
ORDER BY c.id;


-- Resources grouped by sub-category
SELECT
    c.name AS category,
    sc.name AS sub_category,
    COUNT(r.id) AS resource_count
FROM categories c
JOIN sub_categories sc
    ON sc.category_id = c.id
LEFT JOIN resources r
    ON r.sub_category_id = sc.id
GROUP BY
    c.id,
    c.name,
    sc.id,
    sc.name
ORDER BY
    c.id,
    sc.id;


-- Complete resource listing
SELECT
    r.id,
    c.name AS category,
    sc.name AS sub_category,
    r.title,
    r.description,
    r.file_url,
    r.file_size_kb,
    r.download_count,
    r.is_featured,
    r.is_published,
    r.publish_date,
    r.created_at,
    r.updated_at
FROM resources r
JOIN sub_categories sc
    ON sc.id = r.sub_category_id
JOIN categories c
    ON c.id = sc.category_id
ORDER BY r.id;
