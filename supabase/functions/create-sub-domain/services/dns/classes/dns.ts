export class DNSRecord {
  comment: string;
  content: string;
  name: string;
  proxied: boolean;
  ttl: number;
  type: string;

  constructor(data: Partial<DNSRecord>) {
    this.comment = data.comment || "";
    this.content = data.content || "";
    this.name = data.name || "";
    this.proxied = data.proxied || false;
    this.ttl = data.ttl || 0;
    this.type = data.type || "";
  }
}

export class ErrorMessage {
  code: number;
  message: string;

  constructor(data: Partial<ErrorMessage>) {
    this.code = data.code || 0;
    this.message = data.message || "";
  }
}

export class DNSSettings {
  ipv4_only: boolean;
  ipv6_only: boolean;

  constructor(data: Partial<DNSSettings>) {
    this.ipv4_only = data.ipv4_only || false;
    this.ipv6_only = data.ipv6_only || false;
  }
}

export class DNSResult {
  comment: string;
  content: string;
  name: string;
  proxied: boolean;
  settings: DNSSettings;
  tags: string[];
  ttl: number;
  type: string;
  id: string;
  created_on: string;
  meta: Record<string, unknown>;
  modified_on: string;
  proxiable: boolean;
  comment_modified_on: string;
  tags_modified_on: string;

  constructor(data: Partial<DNSResult>) {
    this.comment = data.comment || "";
    this.content = data.content || "";
    this.name = data.name || "";
    this.proxied = data.proxied || false;
    this.settings = new DNSSettings(data.settings || {});
    this.tags = data.tags || [];
    this.ttl = data.ttl || 0;
    this.type = data.type || "";
    this.id = data.id || "";
    this.created_on = data.created_on || "";
    this.meta = data.meta || {};
    this.modified_on = data.modified_on || "";
    this.proxiable = data.proxiable || false;
    this.comment_modified_on = data.comment_modified_on || "";
    this.tags_modified_on = data.tags_modified_on || "";
  }
}

export class DNSResponse {
  errors: ErrorMessage[];
  messages: ErrorMessage[];
  success: boolean;
  result: DNSResult;

  constructor(data: Partial<DNSResponse>) {
    this.errors = (data.errors || []).map((err) => new ErrorMessage(err));
    this.messages = (data.messages || []).map((msg) => new ErrorMessage(msg));
    this.success = data.success || false;
    this.result = new DNSResult(data.result || {});
  }
}

export class DatabaseRecord {
  name: string;
  type: number;
  target: string;
  proxied: boolean = false;

  constructor(data: Partial<DatabaseRecord>) {
    this.name = data.name || "";
    this.type = data.type || 1;
    this.target = data.target || "";
    this.proxied = data.proxied || false;
  }
}
