PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;
PRAGMA user_version = 1;

CREATE TABLE IF NOT EXISTS organizations (
    id TEXT PRIMARY KEY,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    parent_name TEXT,
    address TEXT,
    location TEXT,
    school_year TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    deleted_at TEXT
);

CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    display_name TEXT NOT NULL,
    position TEXT,
    email TEXT,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    deleted_at TEXT
);

CREATE TABLE IF NOT EXISTS user_organizations (
    user_id TEXT NOT NULL REFERENCES users(id),
    organization_id TEXT NOT NULL REFERENCES organizations(id),
    role TEXT NOT NULL DEFAULT 'member',
    is_default INTEGER NOT NULL DEFAULT 0 CHECK (is_default IN (0,1)),
    PRIMARY KEY (user_id, organization_id)
);

CREATE TABLE IF NOT EXISTS units (
    id TEXT PRIMARY KEY,
    organization_id TEXT NOT NULL REFERENCES organizations(id),
    code TEXT,
    name TEXT NOT NULL,
    contact_name TEXT,
    contact_phone TEXT,
    contact_email TEXT,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','archived')),
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    UNIQUE (organization_id, name)
);

CREATE TABLE IF NOT EXISTS reporting_cycles (
    id TEXT PRIMARY KEY,
    organization_id TEXT NOT NULL REFERENCES organizations(id),
    name TEXT NOT NULL,
    period_start TEXT,
    period_end TEXT,
    due_date TEXT,
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','open','closed','archived')),
    created_by TEXT REFERENCES users(id),
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS files (
    id TEXT PRIMARY KEY,
    organization_id TEXT NOT NULL REFERENCES organizations(id),
    relative_path TEXT NOT NULL,
    original_name TEXT NOT NULL,
    mime_type TEXT,
    size_bytes INTEGER NOT NULL CHECK (size_bytes >= 0),
    sha256 TEXT NOT NULL,
    created_by TEXT REFERENCES users(id),
    created_at TEXT NOT NULL,
    deleted_at TEXT,
    UNIQUE (organization_id, sha256)
);

CREATE TABLE IF NOT EXISTS incoming_documents (
    id TEXT PRIMARY KEY,
    organization_id TEXT NOT NULL REFERENCES organizations(id),
    document_no TEXT,
    title TEXT NOT NULL,
    sender TEXT,
    received_date TEXT,
    due_date TEXT,
    status TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new','processing','completed','archived')),
    source_url TEXT,
    created_by TEXT REFERENCES users(id),
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    deleted_at TEXT
);

CREATE TABLE IF NOT EXISTS incoming_document_files (
    incoming_id TEXT NOT NULL REFERENCES incoming_documents(id),
    file_id TEXT NOT NULL REFERENCES files(id),
    PRIMARY KEY (incoming_id, file_id)
);

CREATE TABLE IF NOT EXISTS tasks (
    id TEXT PRIMARY KEY,
    organization_id TEXT NOT NULL REFERENCES organizations(id),
    incoming_id TEXT REFERENCES incoming_documents(id),
    title TEXT NOT NULL,
    owner_user_id TEXT REFERENCES users(id),
    assigned_unit_id TEXT REFERENCES units(id),
    due_date TEXT,
    priority TEXT NOT NULL DEFAULT 'normal' CHECK (priority IN ('low','normal','high','urgent')),
    status TEXT NOT NULL DEFAULT 'todo' CHECK (status IN ('todo','doing','waiting','done','cancelled')),
    completed_at TEXT,
    created_by TEXT REFERENCES users(id),
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    deleted_at TEXT
);

CREATE TABLE IF NOT EXISTS documents (
    id TEXT PRIMARY KEY,
    organization_id TEXT NOT NULL REFERENCES organizations(id),
    incoming_id TEXT REFERENCES incoming_documents(id),
    task_id TEXT REFERENCES tasks(id),
    template_id TEXT,
    title TEXT NOT NULL,
    document_type TEXT,
    status TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft','review','approved','issued','archived')),
    current_version_id TEXT,
    created_by TEXT REFERENCES users(id),
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    deleted_at TEXT
);

CREATE TABLE IF NOT EXISTS document_versions (
    id TEXT PRIMARY KEY,
    document_id TEXT NOT NULL REFERENCES documents(id),
    version_no INTEGER NOT NULL CHECK (version_no > 0),
    file_id TEXT REFERENCES files(id),
    format TEXT NOT NULL DEFAULT 'md' CHECK (format IN ('md','docx','pptx','xlsx')),
    created_by TEXT REFERENCES users(id),
    created_at TEXT NOT NULL,
    UNIQUE (document_id, version_no)
);

CREATE TABLE IF NOT EXISTS document_files (
    document_id TEXT NOT NULL REFERENCES documents(id),
    version_id TEXT REFERENCES document_versions(id),
    file_id TEXT NOT NULL REFERENCES files(id),
    file_role TEXT NOT NULL DEFAULT 'export',
    PRIMARY KEY (document_id, file_id)
);

CREATE TABLE IF NOT EXISTS templates (
    id TEXT PRIMARY KEY,
    organization_id TEXT REFERENCES organizations(id),
    title TEXT NOT NULL,
    document_type TEXT,
    is_reference INTEGER NOT NULL DEFAULT 0 CHECK (is_reference IN (0,1)),
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','archived')),
    created_by TEXT REFERENCES users(id),
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS template_versions (
    id TEXT PRIMARY KEY,
    template_id TEXT NOT NULL REFERENCES templates(id),
    version_no INTEGER NOT NULL CHECK (version_no > 0),
    file_id TEXT NOT NULL REFERENCES files(id),
    created_by TEXT REFERENCES users(id),
    created_at TEXT NOT NULL,
    UNIQUE (template_id, version_no)
);

CREATE TABLE IF NOT EXISTS submissions (
    id TEXT PRIMARY KEY,
    cycle_id TEXT NOT NULL REFERENCES reporting_cycles(id),
    unit_id TEXT NOT NULL REFERENCES units(id),
    version_no INTEGER NOT NULL DEFAULT 1 CHECK (version_no > 0),
    status TEXT NOT NULL DEFAULT 'missing' CHECK (status IN ('missing','received','reviewing','accepted','rejected')),
    received_at TEXT,
    reviewed_by TEXT REFERENCES users(id),
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    UNIQUE (cycle_id, unit_id, version_no)
);

CREATE TABLE IF NOT EXISTS submission_files (
    submission_id TEXT NOT NULL REFERENCES submissions(id),
    file_id TEXT NOT NULL REFERENCES files(id),
    PRIMARY KEY (submission_id, file_id)
);

CREATE TABLE IF NOT EXISTS conversations (
    id TEXT PRIMARY KEY,
    organization_id TEXT NOT NULL REFERENCES organizations(id),
    user_id TEXT REFERENCES users(id),
    task_id TEXT REFERENCES tasks(id),
    document_id TEXT REFERENCES documents(id),
    title TEXT NOT NULL,
    provider TEXT,
    model TEXT,
    status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open','closed','archived')),
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS messages (
    id TEXT PRIMARY KEY,
    conversation_id TEXT NOT NULL REFERENCES conversations(id),
    role TEXT NOT NULL CHECK (role IN ('system','user','assistant','tool')),
    content_file_id TEXT REFERENCES files(id),
    status TEXT NOT NULL DEFAULT 'completed' CHECK (status IN ('queued','running','completed','error','cancelled')),
    error_message TEXT,
    prompt_tokens INTEGER,
    completion_tokens INTEGER,
    created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS message_files (
    message_id TEXT NOT NULL REFERENCES messages(id),
    file_id TEXT NOT NULL REFERENCES files(id),
    PRIMARY KEY (message_id, file_id)
);

CREATE TABLE IF NOT EXISTS memories (
    id TEXT PRIMARY KEY,
    organization_id TEXT NOT NULL REFERENCES organizations(id),
    group_code TEXT NOT NULL,
    title TEXT NOT NULL,
    file_id TEXT REFERENCES files(id),
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','archived')),
    created_by TEXT REFERENCES users(id),
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS audit_logs (
    id TEXT PRIMARY KEY,
    organization_id TEXT REFERENCES organizations(id),
    user_id TEXT REFERENCES users(id),
    action TEXT NOT NULL,
    entity_type TEXT NOT NULL,
    entity_id TEXT,
    details_json TEXT,
    created_at TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS ioffice_connections (
    id TEXT PRIMARY KEY,
    organization_id TEXT NOT NULL REFERENCES organizations(id),
    name TEXT NOT NULL,
    base_url TEXT NOT NULL,
    tenant_code TEXT,
    credential_ref TEXT,
    adapter TEXT NOT NULL DEFAULT 'manual' CHECK (adapter IN ('api','manual','browser')),
    status TEXT NOT NULL DEFAULT 'not_tested' CHECK (status IN ('not_tested','connected','error','disabled')),
    last_sync_at TEXT,
    last_error TEXT,
    created_by TEXT REFERENCES users(id),
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    UNIQUE (organization_id, base_url, tenant_code)
);

CREATE TABLE IF NOT EXISTS ioffice_documents (
    id TEXT PRIMARY KEY,
    connection_id TEXT NOT NULL REFERENCES ioffice_connections(id),
    organization_id TEXT NOT NULL REFERENCES organizations(id),
    remote_id TEXT NOT NULL,
    document_type TEXT NOT NULL CHECK (document_type IN ('incoming','outgoing','directive','report','other')),
    document_no TEXT,
    title TEXT NOT NULL,
    sender TEXT,
    receiver TEXT,
    issued_date TEXT,
    received_date TEXT,
    due_date TEXT,
    remote_status TEXT,
    deep_link TEXT,
    local_file_id TEXT REFERENCES files(id),
    remote_updated_at TEXT,
    synced_at TEXT NOT NULL,
    UNIQUE (connection_id, remote_id)
);

CREATE TABLE IF NOT EXISTS ioffice_assignments (
    id TEXT PRIMARY KEY,
    ioffice_document_id TEXT NOT NULL REFERENCES ioffice_documents(id),
    remote_id TEXT,
    assignee_name TEXT,
    assignee_user_id TEXT REFERENCES users(id),
    assigned_at TEXT,
    due_date TEXT,
    status TEXT NOT NULL DEFAULT 'assigned' CHECK (status IN ('assigned','processing','completed','recalled','unknown')),
    remote_updated_at TEXT,
    synced_at TEXT NOT NULL,
    UNIQUE (ioffice_document_id, remote_id)
);

CREATE TABLE IF NOT EXISTS ioffice_sync_runs (
    id TEXT PRIMARY KEY,
    connection_id TEXT NOT NULL REFERENCES ioffice_connections(id),
    mode TEXT NOT NULL CHECK (mode IN ('manual','scheduled','incremental','full')),
    started_at TEXT NOT NULL,
    finished_at TEXT,
    status TEXT NOT NULL CHECK (status IN ('running','completed','partial','failed')),
    fetched_count INTEGER NOT NULL DEFAULT 0,
    changed_count INTEGER NOT NULL DEFAULT 0,
    error_count INTEGER NOT NULL DEFAULT 0,
    error_message TEXT
);

CREATE INDEX IF NOT EXISTS idx_tasks_org_status_due ON tasks(organization_id, status, due_date);
CREATE INDEX IF NOT EXISTS idx_incoming_org_status_due ON incoming_documents(organization_id, status, due_date);
CREATE INDEX IF NOT EXISTS idx_submissions_cycle_status ON submissions(cycle_id, status);
CREATE INDEX IF NOT EXISTS idx_documents_org_status ON documents(organization_id, status);
CREATE INDEX IF NOT EXISTS idx_messages_conversation_time ON messages(conversation_id, created_at);
CREATE INDEX IF NOT EXISTS idx_audit_entity ON audit_logs(entity_type, entity_id, created_at);
CREATE INDEX IF NOT EXISTS idx_ioffice_documents_due ON ioffice_documents(organization_id, due_date, remote_status);
CREATE INDEX IF NOT EXISTS idx_ioffice_documents_updated ON ioffice_documents(connection_id, remote_updated_at);
CREATE INDEX IF NOT EXISTS idx_ioffice_assignments_status_due ON ioffice_assignments(status, due_date);
CREATE INDEX IF NOT EXISTS idx_ioffice_sync_runs_connection ON ioffice_sync_runs(connection_id, started_at);
