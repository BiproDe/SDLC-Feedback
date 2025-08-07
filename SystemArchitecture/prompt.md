# System Architecture Document - Test Prompts

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

## TC-INF-002: System Architecture - Microservices Migration
**Objective**: Test microservices decomposition and container orchestration

### Primary Prompt:
```
Help me migrate a monolithic .NET application (currently deployed on 3 Windows VMs) to 
a containerized microservices architecture on Azure Kubernetes Service. The application 
has 8 main business domains, handles 50GB of data daily, and integrates with 5 external APIs. 
Include service mesh, monitoring, and blue-green deployment strategy.
```

### Expected Output:
- Microservices decomposition strategy
- Containerization approach (Docker)
- Kubernetes deployment manifests
- Service mesh configuration (Istio/Linkerd)
- CI/CD pipeline for microservices
- Data migration strategy
- API gateway implementation
- Monitoring and observability setup

### Success Criteria:
- ✅ Logical service boundaries identified
- ✅ Container orchestration strategy defined
- ✅ Data consistency approach addressed
- ✅ Deployment and rollback strategies included

---

## TC-INF-011: Multi-Cloud Strategy
**Objective**: Test multi-cloud architecture design

### Primary Prompt:
```
Design a multi-cloud strategy using AWS (primary) and Azure (secondary) for a global 
logistics company. Requirements include data synchronization, workload portability, 
cost optimization, and vendor lock-in mitigation. Include automation for cross-cloud 
deployments and monitoring.
```

### Expected Output:
- Multi-cloud architecture design
- Data synchronization strategy
- Workload portability approach
- Cost optimization techniques
- Vendor lock-in mitigation strategies
- Cross-cloud networking solutions
- Unified monitoring approach
- Automation and deployment strategies

### Success Criteria:
- ✅ Addresses data synchronization challenges
- ✅ Provides workload portability solutions
- ✅ Includes cost optimization strategies
- ✅ Mitigates vendor lock-in risks

---

## TC-INF-012: Legacy System Modernization
**Objective**: Test modernization strategy

### Primary Prompt:
```
Plan the modernization of a 15-year-old mainframe-based inventory management system. 
Current system processes 100K transactions/day, has 5TB of historical data, and integrates 
with 20+ business applications. Design a phased migration to cloud-native architecture 
with minimal business disruption.
```

### Expected Output:
- Current state assessment approach
- Phased migration plan
- Cloud-native target architecture
- Data migration strategy
- Integration modernization approach
- Risk mitigation strategies
- Testing and validation approach
- Rollback procedures

### Success Criteria:
- ✅ Phased approach with clear milestones
- ✅ Minimal business disruption strategy
- ✅ Data integrity and migration plan
- ✅ Risk assessment and mitigation
