# Security Design Document - Test Prompts

## TC-INF-003: Security Design - Zero Trust Implementation
**Objective**: Test security architecture and zero-trust principles

### Primary Prompt:
```
Design a zero-trust security architecture for a hybrid cloud environment hosting sensitive 
financial data. Include identity management, network segmentation, data encryption at rest 
and in transit, API security, and compliance with SOC2 Type II and PCI DSS standards. 
The environment spans on-premises datacenter and AWS cloud.
```

### Expected Output:
- Identity and Access Management (IAM) strategy
- Network micro-segmentation design
- Encryption strategies and key management
- API gateway security implementation
- Zero-trust network architecture
- Continuous monitoring and threat detection
- Compliance framework mapping (SOC2, PCI DSS)
- Incident response procedures

### Success Criteria:
- ✅ Comprehensive zero-trust approach
- ✅ Addresses all compliance requirements
- ✅ Includes specific security controls
- ✅ Covers both hybrid environments

---

## TC-INF-004: Security Design - Container Security
**Objective**: Test container and Kubernetes security knowledge

### Primary Prompt:
```
Implement comprehensive security for a Kubernetes cluster running 50+ microservices 
in production. Include image scanning, runtime security, network policies, secret management, 
RBAC, pod security policies, and vulnerability management. Consider both cluster-level 
and application-level security controls.
```

### Expected Output:
- Container image security and scanning
- Kubernetes RBAC configuration
- Network security policies
- Pod security policies and admission controllers
- Secret and configuration management
- Runtime security monitoring
- Vulnerability management process
- Security logging and auditing

### Success Criteria:
- ✅ Comprehensive K8s security strategy
- ✅ Both preventive and detective controls
- ✅ Scalable security architecture
- ✅ Operational security procedures

---

## Additional Security Test Scenarios

### TC-INF-013: Cloud Security Posture Management
**Objective**: Test cloud security governance and compliance

### Primary Prompt:
```
Design a comprehensive cloud security posture management strategy for a multi-account AWS 
environment with 50+ accounts across development, staging, and production. Include security 
baselines, compliance monitoring, threat detection, incident response, and automated 
remediation. Must comply with ISO 27001 and SOX requirements.
```

### Expected Output:
- Multi-account security governance
- Security baselines and guardrails
- Automated compliance monitoring
- Threat detection and response
- Security automation and orchestration
- Risk assessment framework
- Security metrics and reporting

---

### TC-INF-014: API Security Framework
**Objective**: Test API security design and implementation

### Primary Prompt:
```
Design a comprehensive API security framework for a microservices ecosystem handling 
sensitive customer data. Include authentication, authorization, rate limiting, input 
validation, output sanitization, and API threat protection. The system processes 
1M API calls daily and must comply with GDPR and CCPA regulations.
```

### Expected Output:
- API authentication and authorization strategy
- API gateway security configuration
- Rate limiting and DDoS protection
- Input validation and output sanitization
- API monitoring and threat detection
- Data privacy and protection controls
- Security testing strategies
