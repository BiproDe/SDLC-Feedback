# System Architecture Document - Test Prompts (E-commerce Platform Focus)

## TC-INF-001: System Architecture - E-commerce Platform
**Objective**: Test ability to design scalable e-commerce infrastructure

### Primary Prompt:
```
Design a system architecture for an e-commerce platform that handles 500K daily active users, 
processes $10M in transactions monthly, and requires 99.95% uptime. The system must support 
flash sales with 10x traffic spikes, integrate with multiple payment gateways, and comply 
with PCI DSS requirements. Include disaster recovery for RPO=4hrs, RTO=1hr.
```

### Expected Output:
- Multi-tier architecture (web, app, database layers)
- Load balancing strategies
- Auto-scaling configurations
- Database sharding/replication
- Caching layers (Redis/Memcached)
- CDN implementation
- Security components (WAF, SSL/TLS)
- Monitoring and logging setup

### Success Criteria:
- ✅ Addresses all non-functional requirements
- ✅ Includes specific technology recommendations
- ✅ Considers cost optimization
- ✅ Provides scalability path

---

## TC-INF-001-IAC: Infrastructure as Code - E-commerce Platform
**Objective**: Test ability to generate Infrastructure as Code for the e-commerce architecture

### Primary Prompt:
```
Based on the e-commerce platform architecture we discussed (Azure-based with AKS, Azure SQL, 
Cosmos DB, Redis Cache, Front Door, API Management), generate comprehensive Infrastructure as 
Code templates using Terraform. Include the complete infrastructure setup for production 
environment with proper resource naming, tagging strategy, security configurations, and 
environment separation (dev/staging/prod).
```

### Expected Output:
- Terraform modules for each component (AKS, databases, networking)
- Resource naming and tagging conventions
- Environment-specific variable files
- Security group and network configurations
- Storage and backup configurations
- Monitoring and alerting setup
- Resource dependencies and outputs

### Success Criteria:
- ✅ Complete Terraform templates for all components
- ✅ Proper module structure and reusability
- ✅ Security best practices implemented
- ✅ Environment separation strategy

---

## TC-INF-001-DEVOPS: CI/CD Pipeline - E-commerce Platform
**Objective**: Test DevOps pipeline design and deployment automation

### Primary Prompt:
```
Design a complete CI/CD pipeline for the e-commerce platform microservices using Azure DevOps. 
The pipeline should handle: 8 microservices (User, Product, Cart, Order, Payment, Inventory, 
Notification, Analytics), container builds, security scanning, automated testing, blue-green 
deployments to AKS, and infrastructure deployment. Include branch strategies, approval gates, 
rollback procedures, and monitoring integration.
```

### Expected Output:
- Azure DevOps pipeline YAML files
- Multi-stage deployment strategy
- Container build and push processes
- Security and vulnerability scanning
- Automated testing integration
- Blue-green deployment configuration
- Rollback and monitoring procedures
- Branch protection and approval workflows

### Success Criteria:
- ✅ Complete CI/CD pipeline for microservices
- ✅ Security scanning and compliance checks
- ✅ Blue-green deployment strategy
- ✅ Automated rollback capabilities

---

## TC-INF-001-MONITORING: Observability & Operations
**Objective**: Test comprehensive monitoring and operational excellence setup

### Primary Prompt:
```
Design a comprehensive observability and monitoring solution for the e-commerce platform. 
Include application performance monitoring, infrastructure monitoring, log aggregation, 
alerting strategies, dashboards, and SRE practices. The solution should handle 500K daily 
users, track business KPIs, provide real-time alerts, and support on-call operations with 
proper escalation procedures.
```

### Expected Output:
- Azure Monitor and Application Insights configuration
- Log Analytics workspace and KQL queries
- Custom dashboards and alerting rules
- SLI/SLO definitions and monitoring
- On-call procedures and escalation
- Capacity planning and forecasting
- Business KPI tracking and reporting
- Incident response procedures

### Success Criteria:
- ✅ Complete monitoring stack configuration
- ✅ Business and technical KPI tracking
- ✅ Proactive alerting and escalation
- ✅ Operational runbooks and procedures

---

## TC-INF-001-SECURITY: Security Implementation & Compliance
**Objective**: Test detailed security implementation for PCI DSS compliance

### Primary Prompt:
```
Implement detailed security configurations for the e-commerce platform to achieve PCI DSS 
Level 1 compliance. Include network security policies, identity and access management, 
data encryption strategies, security monitoring, vulnerability management, and compliance 
automation. Provide specific Azure security service configurations and security testing 
procedures.
```

### Expected Output:
- Network security groups and firewall rules
- Azure AD B2C and RBAC configurations
- Key Vault and encryption implementations
- Security monitoring and SIEM setup
- Vulnerability scanning and management
- Compliance automation and reporting
- Security testing and validation procedures
- Incident response and forensics

### Success Criteria:
- ✅ Complete PCI DSS compliance implementation
- ✅ Defense-in-depth security strategy
- ✅ Automated compliance monitoring
- ✅ Security testing and validation procedures
