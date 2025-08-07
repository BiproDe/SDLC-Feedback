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