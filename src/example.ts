/**
 * Example TypeScript module demonstrating best practices and security measures.
 * This file serves as a template for new TypeScript projects.
 */

import { createHash, randomBytes } from 'crypto';
import { readFileSync, writeFileSync } from 'fs';
import { join } from 'path';

// Types and interfaces
interface User {
  id: string;
  name: string;
  email: string;
  role: UserRole;
}

interface ApiResponse<T> {
  data: T;
  status: number;
  message: string;
}

interface Config {
  apiKey: string;
  baseUrl: string;
  timeout: number;
  maxRetries: number;
}

enum UserRole {
  ADMIN = 'admin',
  USER = 'user',
  GUEST = 'guest',
}

// Constants
const DEFAULT_TIMEOUT = 30000;
const MAX_RETRIES = 3;
const ALLOWED_ORIGINS = ['https://example.com', 'https://api.example.com'];

// Utility functions
function validateEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

function sanitizeInput(input: string): string {
  return input
    .replace(/[<>]/g, '')
    .replace(/javascript:/gi, '')
    .replace(/on\w+=/gi, '')
    .trim();
}

function generateSecureToken(): string {
  return randomBytes(32).toString('hex');
}

function hashPassword(password: string): string {
  return createHash('sha256').update(password).digest('hex');
}

// Secure API client class
class SecureApiClient {
  private config: Config;
  private session: any;

  constructor(config: Config) {
    this.config = config;
    this.validateConfig();
  }

  private validateConfig(): void {
    if (!this.config.apiKey || this.config.apiKey.length < 10) {
      throw new Error('Invalid API key provided');
    }
    if (!this.config.baseUrl || !this.config.baseUrl.startsWith('https://')) {
      throw new Error('Invalid base URL. Must use HTTPS');
    }
    if (this.config.timeout <= 0) {
      throw new Error('Timeout must be positive');
    }
  }

  private async makeRequest<T>(
    endpoint: string,
    method: 'GET' | 'POST' | 'PUT' | 'DELETE' = 'GET',
    data?: any
  ): Promise<ApiResponse<T>> {
    const url = `${this.config.baseUrl}/${endpoint.replace(/^\/+/, '')}`;
    
    try {
      const response = await fetch(url, {
        method,
        headers: {
          'Authorization': `Bearer ${this.config.apiKey}`,
          'Content-Type': 'application/json',
          'User-Agent': 'SecureApiClient/1.0',
        },
        body: data ? JSON.stringify(data) : undefined,
        signal: AbortSignal.timeout(this.config.timeout),
      });

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
      }

      const responseData = await response.json();
      return {
        data: responseData,
        status: response.status,
        message: 'Success',
      };
    } catch (error) {
      console.error('API request failed:', error);
      throw error;
    }
  }

  async getUser(userId: string): Promise<User> {
    if (!userId || userId.trim().length === 0) {
      throw new Error('User ID is required');
    }

    const sanitizedUserId = sanitizeInput(userId);
    const response = await this.makeRequest<User>(`users/${sanitizedUserId}`);
    return response.data;
  }

  async createUser(userData: Omit<User, 'id'>): Promise<User> {
    // Validate user data
    if (!userData.name || userData.name.trim().length === 0) {
      throw new Error('User name is required');
    }
    if (!validateEmail(userData.email)) {
      throw new Error('Invalid email format');
    }

    const sanitizedUserData = {
      ...userData,
      name: sanitizeInput(userData.name),
      email: userData.email.toLowerCase().trim(),
    };

    const response = await this.makeRequest<User>('users', 'POST', sanitizedUserData);
    return response.data;
  }
}

// Secure file operations
class SecureFileManager {
  private allowedExtensions = ['.txt', '.json', '.md'];
  private maxFileSize = 1024 * 1024; // 1MB

  private validateFilePath(filePath: string): string {
    const normalizedPath = join(process.cwd(), filePath);
    const allowedDir = join(process.cwd(), 'allowed-files');
    
    if (!normalizedPath.startsWith(allowedDir)) {
      throw new Error('File access outside allowed directory');
    }

    const extension = filePath.toLowerCase().substring(filePath.lastIndexOf('.'));
    if (!this.allowedExtensions.includes(extension)) {
      throw new Error('File type not allowed');
    }

    return normalizedPath;
  }

  readFile(filePath: string): string {
    try {
      const validatedPath = this.validateFilePath(filePath);
      const content = readFileSync(validatedPath, 'utf-8');
      
      if (content.length > this.maxFileSize) {
        throw new Error('File too large');
      }

      return content;
    } catch (error) {
      console.error('File read error:', error);
      throw error;
    }
  }

  writeFile(filePath: string, content: string): void {
    try {
      const validatedPath = this.validateFilePath(filePath);
      const sanitizedContent = sanitizeInput(content);
      writeFileSync(validatedPath, sanitizedContent, 'utf-8');
    } catch (error) {
      console.error('File write error:', error);
      throw error;
    }
  }
}

// Input validation middleware
function validateOrigin(origin: string): boolean {
  return ALLOWED_ORIGINS.includes(origin);
}

function validateUserInput(input: any): boolean {
  if (typeof input !== 'string') {
    return false;
  }

  const dangerousPatterns = [
    /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi,
    /javascript:/gi,
    /data:text\/html/gi,
    /vbscript:/gi,
    /on\w+\s*=/gi,
  ];

  return !dangerousPatterns.some(pattern => pattern.test(input));
}

// Main application class
class SecureApplication {
  private apiClient: SecureApiClient;
  private fileManager: SecureFileManager;

  constructor(config: Config) {
    this.apiClient = new SecureApiClient(config);
    this.fileManager = new SecureFileManager();
  }

  async processUserRequest(userId: string, userInput: string): Promise<User> {
    // Validate all inputs
    if (!validateUserInput(userInput)) {
      throw new Error('Invalid user input detected');
    }

    if (!userId || userId.trim().length === 0) {
      throw new Error('User ID is required');
    }

    // Process the request
    const user = await this.apiClient.getUser(userId);
    console.log(`Processed request for user: ${user.name}`);
    
    return user;
  }

  async handleFileOperation(filePath: string, operation: 'read' | 'write', content?: string): Promise<string | void> {
    if (operation === 'read') {
      return this.fileManager.readFile(filePath);
    } else if (operation === 'write' && content) {
      this.fileManager.writeFile(filePath, content);
    }
  }
}

// Example usage
async function main(): Promise<void> {
  try {
    const config: Config = {
      apiKey: process.env.API_KEY || '',
      baseUrl: process.env.API_BASE_URL || 'https://api.example.com',
      timeout: DEFAULT_TIMEOUT,
      maxRetries: MAX_RETRIES,
    };

    const app = new SecureApplication(config);
    
    // Example: Process user request
    const user = await app.processUserRequest('12345', 'safe input');
    console.log('User retrieved:', user.name);

    // Example: File operation
    const fileContent = await app.handleFileOperation('example.txt', 'read') as string;
    console.log('File content:', fileContent);

  } catch (error) {
    console.error('Application error:', error);
    process.exit(1);
  }
}

// Export for use in other modules
export {
  SecureApiClient,
  SecureFileManager,
  SecureApplication,
  validateEmail,
  sanitizeInput,
  generateSecureToken,
  hashPassword,
  validateOrigin,
  validateUserInput,
  User,
  Config,
  UserRole,
  ApiResponse,
};

// Run main function if this is the entry point
if (require.main === module) {
  main();
} 