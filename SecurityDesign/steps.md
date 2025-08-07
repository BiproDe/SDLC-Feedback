# Security Design Testing Steps

## General Testing Approach

### Pre-Test Setup (5 minutes)
1. **Open VS Code**
2. **Open Copilot Chat** (`Ctrl+Shift+I`)
3. **Start new chat session** for security focus
4. **Prepare timer** for response tracking
5. **Have security prompt file open**

### Test Execution Steps

#### Step 1: Initial Security Prompt Testing (10-15 minutes)
1. **Copy the primary prompt** from prompt.md
2. **Paste into Copilot Chat**
3. **Record start time**
4. **Wait for response** and record response time
5. **Evaluate security comprehensiveness** against expected output
6. **Rate security expertise level** (1-10 scale)

#### Step 2: Security-Specific Follow-up Questions (20-25 minutes)

**For TC-INF-003 (Zero Trust Implementation):**
1. "How would you implement conditional access policies for this architecture?"
2. "What specific encryption algorithms and key lengths do you recommend?"
3. "Can you provide detailed network segmentation rules and firewall configurations?"
4. "How would you handle privileged access management (PAM) in this environment?"
5. "What are the specific SOC2 Type II controls we need to implement?"
6. "How would you detect and respond to insider threats in this architecture?"
7. "Can you generate AWS security group rules and NACLs for this design?"

**For TC-INF-004 (Container Security):**
1. "What specific image scanning tools and policies would you implement?"
2. "Can you provide Kubernetes RBAC YAML manifests for role-based access?"
3. "How would you implement runtime threat detection for containers?"
4. "What are the specific network policies to isolate microservices?"
5. "How would you handle secrets rotation in this Kubernetes environment?"
6. "What admission controller policies would you recommend?"
7. "How would you implement container image signing and verification?"

**For TC-INF-013 (Cloud Security Posture):**
1. "What specific AWS Config rules would you implement for compliance?"
2. "How would you automate security baseline deployment across 50+ accounts?"
3. "What are the specific ISO 27001 controls we need to address?"
4. "Can you provide CloudFormation/Terraform for security automation?"
5. "How would you implement cross-account security monitoring?"
6. "What metrics would you track for security posture measurement?"

**For TC-INF-014 (API Security):**
1. "What specific OAuth 2.0 / OpenID Connect implementation would you recommend?"
2. "How would you implement API rate limiting to prevent abuse?"
3. "What input validation rules are critical for API security?"
4. "How would you handle API versioning from a security perspective?"
5. "What specific GDPR compliance measures are needed for API data handling?"
6. "Can you provide API gateway configuration for threat protection?"

#### Step 3: Security Deep Dive Testing (15-20 minutes)

**Threat Modeling Questions:**
1. "What are the top 5 security threats for this architecture?"
2. "How would you perform threat modeling for this system?"
3. "What attack vectors are we most vulnerable to?"

**Compliance Deep Dive:**
1. "Can you map each security control to specific compliance requirements?"
2. "What evidence would auditors need to see for compliance verification?"
3. "How would you automate compliance reporting?"

**Incident Response Testing:**
1. "Walk me through the incident response process for a data breach"
2. "How would you contain a security incident in this architecture?"
3. "What forensic capabilities do you recommend?"

**Security Automation:**
1. "Can you generate security automation scripts (Python/PowerShell)?"
2. "How would you implement security-as-code practices?"
3. "What security testing should be integrated into CI/CD pipelines?"

#### Step 4: Practical Security Implementation (10-15 minutes)

**Request Specific Configurations:**
1. **Security Policies**: "Generate AWS IAM policies for least privilege access"
2. **Network Security**: "Provide firewall rules and security group configurations"
3. **Monitoring Rules**: "Create security monitoring and alerting configurations"
4. **Compliance Scripts**: "Generate automated compliance checking scripts"

**Test Edge Cases:**
1. "How do you handle security during system outages?"
2. "What happens if the identity provider becomes compromised?"
3. "How do you maintain security during emergency maintenance?"

## Security-Specific Evaluation Criteria

### Security Expertise Level (1-10 Scale)
- **9-10**: Expert security knowledge, addresses advanced threats
- **7-8**: Good security understanding with comprehensive approach
- **5-6**: Basic security knowledge but misses critical elements
- **3-4**: Limited security understanding with gaps
- **1-2**: Poor security knowledge, potential vulnerabilities

### Threat Coverage (1-10 Scale)
- **9-10**: Addresses all major threat vectors comprehensively
- **7-8**: Covers most threats with good defensive strategies
- **5-6**: Basic threat coverage but misses some important vectors
- **3-4**: Limited threat awareness
- **1-2**: Poor threat understanding, leaves major gaps

### Compliance Understanding (1-10 Scale)
- **9-10**: Deep compliance knowledge with specific control mapping
- **7-8**: Good compliance understanding with practical approach
- **5-6**: Basic compliance knowledge but lacks specifics
- **3-4**: Limited compliance understanding
- **1-2**: Poor or incorrect compliance guidance

### Security Best Practices (1-10 Scale)
- **9-10**: Follows all security best practices and industry standards
- **7-8**: Generally good security practices with minor gaps
- **5-6**: Some security practices followed, others missed
- **3-4**: Limited adherence to security best practices
- **1-2**: Poor security practices, potential security risks

## Critical Security Elements to Verify

### Authentication & Authorization
- ✅ Multi-factor authentication implementation
- ✅ Role-based access control (RBAC)
- ✅ Principle of least privilege
- ✅ Identity federation and SSO

### Data Protection
- ✅ Encryption at rest and in transit
- ✅ Key management strategy
- ✅ Data classification and handling
- ✅ Data loss prevention (DLP)

### Network Security
- ✅ Network segmentation and micro-segmentation
- ✅ Firewall and security group configurations
- ✅ Intrusion detection and prevention
- ✅ Secure network protocols

### Monitoring & Response
- ✅ Security information and event management (SIEM)
- ✅ Threat detection and analytics
- ✅ Incident response procedures
- ✅ Security metrics and reporting

### Compliance & Governance
- ✅ Regulatory compliance mapping
- ✅ Security policies and procedures
- ✅ Risk assessment and management
- ✅ Security training and awareness

## Red Flags to Watch For

### Major Security Concerns:
- ❌ Recommends insecure protocols or weak encryption
- ❌ Ignores principle of least privilege
- ❌ Lacks multi-factor authentication
- ❌ Poor secret management practices
- ❌ Inadequate logging and monitoring
- ❌ Missing input validation or sanitization
- ❌ Incorrect compliance guidance

### Documentation Requirements

**Security Test Result Template:**
```markdown
# Security Design Test Result

**Test Case**: [TC-INF-XXX]
**Date**: [Date]
**Security Focus Area**: [Zero Trust/Container/API/Cloud Posture]
**Duration**: [Total Time]

## Security Assessment
- **Security Expertise Level**: [X/10]
- **Threat Coverage**: [X/10]
- **Compliance Understanding**: [X/10]
- **Security Best Practices**: [X/10]

## Specific Security Strengths
- [List security controls properly addressed]
- [Compliance requirements met]
- [Security best practices followed]

## Security Gaps Identified
- [List missing security controls]
- [Compliance gaps found]
- [Security best practices missed]

## Risk Assessment
**Security Risk Level**: [High/Medium/Low]
**Compliance Risk**: [High/Medium/Low]
**Production Security Readiness**: [Ready/Needs Work/Not Ready]

## Recommendations
- [Security improvements needed]
- [Additional security testing required]
- [Training or documentation needs]
```

## Security Testing Success Tips

1. **Think Like an Attacker**: Consider how systems could be compromised
2. **Verify Compliance**: Ensure all regulatory requirements are addressed
3. **Test Defense in Depth**: Look for multiple layers of security controls
4. **Check for Real-World Threats**: Validate against current threat landscape
5. **Assess Operational Security**: Consider day-to-day security operations
6. **Validate Automation**: Ensure security can scale with the system
