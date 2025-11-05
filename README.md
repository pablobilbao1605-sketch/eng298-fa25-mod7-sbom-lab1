# UIUC ENG 298 - Fall 2025  
## Module 7: Assignment: Secure Software Supply Chain with Software Bill of Materials (SBOMs)

## **Assignment Overview**

A **supply chain** is the network of people, processes, technologies, and organizations involved in creating and delivering a product or service, from raw materials to the end user. A **software supply chain** refers to all the components, dependencies, and tools used to build, deploy, and maintain software systems.

In this lab, you will apply Security Engineering principles - open design, least privilege, **complete mediation** (every access to every resource must be checked for authorization - every time <a href="https://doi.org/10.1109/PROC.1975.9939" target="_blank">(Saltzer & Schroeder, 1975)</a>), and defense in depth - to the software supply chain. Modern systems depend on many third-party components. Knowing what’s inside a system is essential to designing, verifying, and maintaining secure software. An SBOM provides this transparency by listing every package, library, and dependency that makes up an application or container. You will use GitHub Codespaces and open-source tools to generate, analyze, and compare SBOMs for the NG911 software repository, then reflect on how this information supports secure design and lifecycle assurance.

You will use GitHub Codespaces and open-source tools to generate, analyze, and compare SBOMs for a software repository, then reflect on how this information supports secure design and lifecycle assurance.

---

## **Learning Objectives**

You will learn to generate, analyze, and interpret both artifacts. By the end of this lab, you should be able to:

- Explain how SBOMs support security-by-design and verification/validation activities.
- Relate SBOM use to Security Engineering principles (e.g., open design, least privilege, defense in depth).
- Generate an SBOM from a software repository using **Syft** and **Trivy**.  
- Compare and interpret SBOM outputs in SPDX/JSON formats.  
- Perform a vulnerability analysis using **Grype**.  
- Interpret and document CVE findings.
- Identify potential risks or missing information in component inventories

---

## **Lab Context**

In the Module 7 Reading Material and lecture discussions, you explored how assurance, verification, and transparency strengthen system design and maintenance. This lab extends those principles into the software supply chain, where complex dependencies make it difficult to know exactly what’s running in a system. By generating and analyzing SBOMs for the **NG911** application - software that aligns with the [NENA/NG911](https://www.nena.org/page/ng911_project) standards defining the architecture and interoperability framework for Next Generation 9-1-1 systems - you’ll apply the same engineering mindset of identifying components, validating integrity, and reducing uncertainty to software, reinforcing the role of visibility as a foundation for trust.

---

### **HBOM vs. SBOM Explained**

| **Aspect** | **SBOM** | **HBOM** |
|-------------|-----------|-----------|
| **Purpose** | Tracks software components, versions, and known CVEs. | Tracks hardware components, part numbers, and suppliers. |
| **Focus** | Software supply-chain risk (vulnerable libraries). | Hardware provenance and tampering risk (counterfeit or insecure chips). |
| **Contents** | Package names, versions, dependencies, licenses, CVEs. | Chipsets, sensors, SoCs, communication modules, firmware IDs. |
| **Common Formats** | SPDX, CycloneDX, Syft JSON. | IPC-1752A, IPC-1754, or vendor-specific CSV/XML formats. |
| **Key Users** | Developers, vulnerability managers, software assurance teams. | OEMs, supply-chain analysts, hardware security engineers. |
| **Tagline** | *“What’s in the code.”* | *“What’s on the board.”* |

---

## **Resources**

- [Idaho National Lab (INL) SBOM Portal](https://sbom.inl.gov)  
- [National Vulnerability Database (NVD)](https://nvd.nist.gov/vuln/search)

---

## **Tools Overview**

### **Syft**
- SBOM generator that inspects a filesystem, container image, or repository.  
- Reports packages, versions, and dependencies.  
- Open source (by Anchore).  
- Produces rich metadata; integrates with CI/CD pipelines.

### **Trivy**
- Open-source scanner (by Aqua Security).  
- Scans repos, filesystems, and container images.  
- Detects OS packages, app libraries, and misconfigurations.  
- Fast and broadly applicable.

### **Grype**
- Vulnerability scanner (by Anchore).  
- Works directly with SBOMs or images.  
- Focuses on known vulnerabilities (CVEs).  
- Pairs well with Syft in CI pipelines.

---

### **Report Deliverable**

Throughout this lab, you will capture your commands, screenshots, and findings in a short report (2-3 pages total). This report will compile your SBOM generation results and vulnerability analysis (top 5 CVEs). The final report, along with the required output files, will be submitted in your Codespace’s deliverables/folder and pushed to GitHub.

---

## **Part 1: SBOM Generation (in Codespaces)**

All commands can be executed directly inside your GitHub Codespace using this repo:

👉 [https://github.com/obriencasey/eng298-fa25-mod7-sbom-lab](https://github.com/obriencasey/cs460-fa-25-hbom-sbom-lab)

### **Steps**

1. **Clone the NG911 software repository:**

   ```bash
   git clone https://github.com/m5stack/M5Cardputer.git
   
   # or
   
   git clone https://github.com/m5stack/M5StampFly.git
   
   # or
   
   git clone https://github.com/m5stack/M5StamPLC.git
   ```

2. **Navigate to the firmware folder:**

   ```bash
   cd M5Cardputer
   ```

3. **Generate an SBOM in SPDX format (Syft):**

   ```bash
   syft . -o spdx-json > ../deliverables/sbom_syft_spdx.json
   ```

4. **Generate a CycloneDX SBOM (Trivy):**

   ```bash
   trivy fs . --format cyclonedx --output ../deliverables/sbom_trivy_cdx.json
   ```

5. **Record in your report:**
   - Number of components each tool reports.  
   - One key difference (format, fields, or component count).  
   - Screenshots of terminal output.

6. **Confirm SBOM files exist:**

   ```bash
   ls ../deliverables/
   ```

---

## **Part 2: SBOM Vulnerability Analysis**

1. **Feed the SBOM into Grype:**

   ```bash
   grype sbom:../deliverables/sbom_syft_spdx.json -o table > ../deliverables/vuln_analysis_grype.txt
   ```

   > ✅ If Grype reports zero vulnerabilities, that’s fine - include an explanation of why.

2. **In your report, include a Top 5 Vulnerabilities table:**

   | **CVE** | **Severity** | **Component** | **Version** | **Comment** |
   |----------|---------------|----------------|--------------|--------------|
   | CVE-2023-0286 | High | OpenSSL | 3.0.2 | TLS certificate validation bypass |

3. **Preview output:**

   ```bash
   head -20 ../deliverables/vuln_analysis_grype.txt
   ```

4. **Select one CVE** and summarize its cause or impact using NVD.

---

## **Part 3: HBOM Exploration**

Use the device documentation to identify **three (3)** key hardware components (e.g., microcontroller, IMU, LCD).

For each component, provide:
- **Manufacturer** (e.g., Espressif, Epson)  
- **Part number or chip family** (e.g., ESP32-S3, MPU6886)  
- **Known vulnerabilities or risks** (from NVD or functional reasoning)  
- **Summary** of how hardware dependencies influence software risk.

---

## **Part 4: Deliverables**

Submit a **2–3 page report** including:

- SBOM generation results  
- Vulnerability analysis (top 5 CVEs or rationale for zero matches)  
- HBOM component summary  
- Reflection on insights and process  

### **Upload to `/deliverables/` and push to GitHub:**

```
deliverables/
│
├── sbom_syft_spdx.json
├── sbom_trivy_cdx.json
├── vuln_analysis_grype.txt
├── hbom_summary.md
└── reflection.md
```

---

## **Grading Rubric (25 Points Total)**

| **Criterion** | **Excellent (Full Points)** | **Partial Credit** | **Points** |
|----------------|-----------------------------|--------------------|------------|
| **SBOM Generation** | Both SBOMs generated (Syft SPDX + Trivy CycloneDX); includes discussion of differences and screenshots. | One SBOM missing, misnamed, or lacking discussion. | 8 |
| **Vulnerability Analysis** | Grype scan performed; top 5 CVEs or rationale for 0 findings; NVD context explained. | Scan missing or minimal discussion. | 7 |
| **HBOM Exploration** | Three components documented with vendor, part #, and vulnerability context. | Fewer than three components or minimal discussion. | 6 |
| **Reflection & Professionalism** | Clear, concise reflection; correct filenames; properly pushed to GitHub. | Minor clarity or submission issues. | 4 |
