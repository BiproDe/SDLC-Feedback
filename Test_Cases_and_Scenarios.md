# Infrastructure SME Test Cases & Sample Scenarios

## Test Case Template for Infrastructure Deliverables

### Test Case Format:
**TC-INF-[Number]: [Deliverable Type] - [Scenario Name]**
- **Objective**: What you want to test
- **Input Prompt**: Exact prompt to give the agent
- **Expected Output**: What a good response should include
- **Success Criteria**: How to measure success
- **Time Estimate**: Expected time investment

---

## 🏗️ System Architecture Document Test Cases

### TC-INF-001: System Architecture - E-commerce Platform
**Objective**: Test ability to design scalable e-commerce infrastructure
**Input Prompt**: 
```
"Design a system architecture for an e-commerce platform that handles 500K daily active users, 
processes $10M in transactions monthly, and requires 99.95% uptime. The system must support 
flash sales with 10x traffic spikes, integrate with multiple payment gateways, and comply 
with PCI DSS requirements. Include disaster recovery for RPO=4hrs, RTO=1hr."
```
**Expected Output**:
- Multi-tier architecture (web, app, database layers)
- Load balancing strategies
- Auto-scaling configurations
- Database sharding/replication
- Caching layers (Redis/Memcached)
- CDN implementation
- Security components (WAF, SSL/TLS)
- Monitoring and logging setup

**Success Criteria**:
- ✅ Addresses all non-functional requirements
- ✅ Includes specific technology recommendations
- ✅ Considers cost optimization
- ✅ Provides scalability path

---

### TC-INF-002: System Architecture - Microservices Migration
**Objective**: Test microservices decomposition and container orchestration
**Input Prompt**: 
```
"Help me migrate a monolithic .NET application (currently deployed on 3 Windows VMs) to 
a containerized microservices architecture on Azure Kubernetes Service. The application 
has 8 main business domains, handles 50GB of data daily, and integrates with 5 external APIs. 
Include service mesh, monitoring, and blue-green deployment strategy."
```

---

## 🔒 Security Design Document Test Cases

### TC-INF-003: Security Design - Zero Trust Implementation
**Objective**: Test security architecture and zero-trust principles
**Input Prompt**: 
```
"Design a zero-trust security architecture for a hybrid cloud environment hosting sensitive 
financial data. Include identity management, network segmentation, data encryption at rest 
and in transit, API security, and compliance with SOC2 Type II and PCI DSS standards. 
The environment spans on-premises datacenter and AWS cloud."
```

**Expected Output**:
- Identity and Access Management (IAM) strategy
- Network micro-segmentation
- Encryption strategies and key management
- API gateway security
- Monitoring and threat detection
- Compliance framework mapping

---

### TC-INF-004: Security Design - Container Security
**Objective**: Test container and Kubernetes security knowledge
**Input Prompt**: 
```
"Implement comprehensive security for a Kubernetes cluster running 50+ microservices 
in production. Include image scanning, runtime security, network policies, secret management, 
RBAC, pod security policies, and vulnerability management. Consider both cluster-level 
and application-level security controls."
```

---

## 💾 Data Design Document Test Cases

### TC-INF-005: Data Design - Multi-Region Database Strategy
**Objective**: Test database architecture and data management
**Input Prompt**: 
```
"Design a global data architecture for a SaaS application serving customers in North America, 
Europe, and Asia. Requirements include data locality compliance (GDPR), 24/7 availability, 
cross-region data synchronization, and the ability to handle 1TB of new data monthly. 
Include backup, archiving, and disaster recovery strategies."
```

**Expected Output**:
- Multi-region database setup
- Data replication strategy
- Backup and archiving policies
- Compliance and data residency
- Performance optimization
- Cost management

---

## 🔗 Integration Design Document Test Cases

### TC-INF-006: Integration Design - API Gateway and Service Mesh
**Objective**: Test API management and service communication
**Input Prompt**: 
```
"Design an integration architecture for a company acquiring 3 smaller companies. Need to 
integrate their existing systems (REST APIs, SOAP services, and message queues) into a 
unified platform while maintaining backward compatibility. Include API versioning, 
rate limiting, monitoring, and gradual migration strategy."
```

---

## 📊 Additional Infrastructure-Specific Test Cases

### TC-INF-007: IaC Template Generation
**Objective**: Test Infrastructure as Code capabilities
**Input Prompt**: 
```
"Generate Terraform templates for a 3-tier web application on AWS including VPC, subnets, 
security groups, ALB, Auto Scaling Groups, RDS with Multi-AZ, ElastiCache, and CloudFront. 
Include proper tagging strategy, cost optimization, and security best practices."
```

### TC-INF-008: Monitoring and Observability
**Objective**: Test monitoring solution design
**Input Prompt**: 
```
"Design a comprehensive monitoring and observability strategy for a microservices application 
running on Kubernetes. Include metrics, logs, traces, alerting, and dashboards. Consider both 
infrastructure and application monitoring with SLA/SLO tracking for 99.9% availability target."
```

### TC-INF-009: Disaster Recovery Planning
**Objective**: Test DR strategy development
**Input Prompt**: 
```
"Create a disaster recovery plan for a critical banking application with RTO=15 minutes 
and RPO=5 minutes. The primary site is in East Coast USA, design the secondary site 
strategy, failover procedures, and testing protocols. Include cost analysis and 
regular DR testing schedule."
```

### TC-INF-010: Performance Optimization
**Objective**: Test performance tuning knowledge
**Input Prompt**: 
```
"A web application is experiencing slow response times during peak hours (2-3 seconds 
average, goal is <500ms). Current setup: 2 web servers, 1 database server, no caching. 
Peak load: 1000 concurrent users. Analyze performance bottlenecks and provide optimization 
recommendations with implementation priority."
```

---

## 🎯 Advanced Scenario Test Cases

### TC-INF-011: Multi-Cloud Strategy
**Objective**: Test multi-cloud architecture design
**Input Prompt**: 
```
"Design a multi-cloud strategy using AWS (primary) and Azure (secondary) for a global 
logistics company. Requirements include data synchronization, workload portability, 
cost optimization, and vendor lock-in mitigation. Include automation for cross-cloud 
deployments and monitoring."
```

### TC-INF-012: Legacy System Modernization
**Objective**: Test modernization strategy
**Input Prompt**: 
```
"Plan the modernization of a 15-year-old mainframe-based inventory management system. 
Current system processes 100K transactions/day, has 5TB of historical data, and integrates 
with 20+ business applications. Design a phased migration to cloud-native architecture 
with minimal business disruption."
```

## 📝 Feedback Recording Template

For each test case, use this template in your feedback:

**Test Case ID**: TC-INF-[Number]
**Date/Time**: [Date] [Start Time] - [End Time]
**Total Duration**: [X] minutes

**Time Breakdown**:
- Prompt preparation: [X] minutes
- Agent response time: [X] minutes
- Review and evaluation: [X] minutes

**Quality Assessment**:
- Technical Accuracy: [1-10]
- Completeness: [1-10]
- Best Practices: [1-10]
- Practical Implementation: [1-10]

**Time Saving Estimate**: [X]%
**Quality Outcome**: [Unacceptable/Acceptable/Above Expectation/Exceptional]

**Specific Observations**:
- ✅ What worked well:
- ❌ What were the gaps:
- 💡 Unexpected insights:
- 🔧 Recommendations for improvement:

**Business Value Assessment**:
- Would you use this in production? [Yes/No/With modifications]
- Risk level for adopting this solution: [High/Medium/Low]
- Recommended use cases: [List specific scenarios]

## 💡 Pro Tips for Effective Testing

1. **Vary Complexity**: Start with simple scenarios, gradually increase complexity
2. **Test Edge Cases**: Include unusual requirements or constraints
3. **Follow-up Questions**: Ask for clarification or modifications to test adaptability
4. **Real-world Context**: Use actual business scenarios from your experience
5. **Time Boxing**: Limit each test to 30-45 minutes to maintain focus
6. **Document Everything**: Capture both successful and unsuccessful interactions
7. **Cross-verify**: When possible, validate agent responses against known solutions

Remember: Your expertise is invaluable in determining whether these agents can truly support infrastructure teams in real-world scenarios!
