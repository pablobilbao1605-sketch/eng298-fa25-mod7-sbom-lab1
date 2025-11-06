# UIUC ENG 298 - Fall 2025  
## Module 7: Assignment: Secure Software Supply Chain with Software Bill of Materials (SBOMs)

## **Assignment Overview**

A **supply chain** is the network of people, processes, technologies, and organizations involved in creating and delivering a product or service, from raw materials to the end user. A **software supply chain** refers to all the components, dependencies, and tools used to build, deploy, and maintain software systems.

In this lab, you will apply Security Engineering principles - open design, least privilege, **complete mediation** (every access to every resource must be checked for authorization - every time <a href="https://doi.org/10.1109/PROC.1975.9939" target="_blank">(Saltzer & Schroeder, 1975)</a>), and defense in depth - to the software supply chain. Modern systems depend on many third-party components. Knowing what’s inside a system is essential to designing, verifying, and maintaining secure software. An SBOM provides this transparency by listing every package, library, and dependency that makes up an application or container. You will use GitHub Codespaces and open-source tools to generate, analyze, and compare SBOMs for the NG911 software repository, then reflect on how this information supports secure design and lifecycle assurance.

You will use GitHub Codespaces and open-source tools to generate, analyze, and compare SBOMs for a software repository, then reflect on how this information supports secure design and lifecycle assurance.


## **Learning Objectives**

You will learn to generate, analyze, and interpret both artifacts. By the end of this lab, you should be able to:

- Explain how SBOMs support security-by-design and verification/validation activities.
- Relate SBOM use to Security Engineering principles (e.g., open design, least privilege, defense in depth).
- Generate an SBOM from a software repository using **Syft** and **Trivy**.  
- Compare and interpret SBOM outputs in SPDX/JSON formats.  
- Perform a vulnerability analysis using **Grype**.  
- Interpret and document CVE findings.
- Identify potential risks or missing information in component inventories

## **Lab Context**

In the Module 7 Reading Material and lecture discussions, you explored how assurance, verification, and transparency strengthen system design and maintenance. This lab extends those principles into the software supply chain, where complex dependencies make it difficult to know exactly what’s running in a system. By generating and analyzing SBOMs for the **NG911** application - software that aligns with the [NENA/NG911](https://www.nena.org/page/ng911_project) standards defining the architecture and interoperability framework for Next Generation 9-1-1 systems - you’ll apply the same engineering mindset of identifying components, validating integrity, and reducing uncertainty to software, reinforcing the role of visibility as a foundation for trust.

### **HBOM vs. SBOM Explained**

| **Aspect** | **SBOM** | **HBOM** |
|-------------|-----------|-----------|
| **Purpose** | Tracks software components, versions, and known CVEs. | Tracks hardware components, part numbers, and suppliers. |
| **Focus** | Software supply-chain risk (vulnerable libraries). | Hardware provenance and tampering risk (counterfeit or insecure chips). |
| **Contents** | Package names, versions, dependencies, licenses, CVEs. | Chipsets, sensors, SoCs, communication modules, firmware IDs. |
| **Common Formats** | SPDX, CycloneDX, Syft JSON. | IPC-1752A, IPC-1754, or vendor-specific CSV/XML formats. |
| **Key Users** | Developers, vulnerability managers, software assurance teams. | OEMs, supply-chain analysts, hardware security engineers. |
| **Tagline** | *“What’s in the code.”* | *“What’s on the board.”* |

## **Resources**

- [Idaho National Lab (INL) SBOM Portal](https://sbom.inl.gov)  
- [National Vulnerability Database (NVD)](https://nvd.nist.gov/vuln/search)

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

### **Report Deliverable**

Throughout this lab, you will capture your commands, screenshots, and findings in a short report (2-3 pages total, PDF format). This report will compile your SBOM generation results and vulnerability analysis (top 5 CVEs). The final report, along with the required output files, will be submitted in your Codespace’s /deliverables folder and pushed to GitHub. **See Part 3: Deliverables below for more information.**

## **Part 1: SBOM Generation (in Codespaces)**

All commands can be executed directly inside your GitHub Codespace using this repo.

### **Steps**

1. Run the following command in your Codespace terminal to clone the NG911 repository:

   ```bash
   git clone https://github.com/tamu-edu/ng911-dev.git
   ```

**Syntax Breakdown**:

**git** This invokes the **Git** command-line tool — the version control system used to manage source code repositories.

**clone** Git subcommand that creates a copy of a remote repository (like one hosted on GitHub) on your local machine or Codespace. It:  
1. Downloads all files and directories from the repo.  
2. Preserves the commit history and branches.  
3. Automatically configures a connection (called a *remote*) to the source repository.

**https://github.com/tamu-edu/ng911-dev.git** URL of the remote repository you want to clone.

**Let’s break that URL down further:** 

| **Part** | **Meaning** |
|-----------|-------------|
| `https://` | Uses HTTPS protocol for secure download (instead of SSH or Git). |
| `github.com` | The host (GitHub) where the repo lives. |
| `tamu-edu` | The GitHub organization (Texas A&M University). |
| `ng911-dev` | The repository name. |
| `.git` | Tells Git this is a repository endpoint, not a webpage. |

   This will download the NG911 source code into your Codespace environment so you can generate and analyze its SBOM.

2. Change into that folder, for example:

   ```bash
   cd ng911-dev
   ```

3. Generate an SBOM in SPDX format (Syft):

   ```bash
   syft . -o spdx-json > ../deliverables/sbom_syft_spdx.json
   ```
**Syntax Breakdown**:

**syft** Open-source command-line tool used to generate an SBOM. Scans a project or container image to identify all the packages and dependencies present

**.** The single dot (.) means “the current directory.” Syft will analyze all files and packages in the current working directory, which is ng911-dev 

**-o spdx-json** Program option (*-o*) specifying the output format. Here, spdx-json tells Syft to format the results using the SPDX (Software Package Data Exchange) standard, in JSON form.

**>** This is a redirection operator in the Linux shell. It takes the output that would normally print to the terminal (your screen) and redirects it to a file instead

**../deliverables/sbom_syft_spdx.json** This is the destination path and filename for the SBOM output:

.. → Go up one directory level from your current folder

/deliverables/ → Inside that parent directory, place the file in the deliverables folder

*sbom_syft_spdx.json* → Name of the generated SBOM file

So the full path means: “Save the SBOM JSON file one level up, inside the deliverables directory.”

4. Generate a CycloneDX SBOM (Trivy):

   ```bash
   trivy fs . --format cyclonedx --output ../deliverables/sbom_trivy_cdx.json
   ```
**Syntax Breakdown**:

**trivy** Open-source command-line tool used to generate SBOMs as well as scan filesystems, containers, and repositories for vulnerabilities

**fs** Program sub-command, short for **filesystem**, tells Trivy to scan the local files and directories (not a Docker image or repo)

**.** The single dot (.) means “the current directory.” Trivy will inspect all the code and dependencies in your current working, which is *ng911-dev* 

**--format cyclonedx** Program option (*--format*) specifying the output format. Here, *cyclonedx* tells Trivy to generate the SBOM in the CycloneDX format (an alternative to SPDX)

**--output ../deliverables/sbom_trivy_cdx.json** Program option (*--output*) defines where and what to name the output file:

.. → Go up one directory level from the current folder

/deliverables/ → Save it inside the deliverables directory

*sbom_trivy_cdx.json* → The name of the generated CycloneDX SBOM file

So the file will be created as ../deliverables/sbom_trivy_cdx.json

5. After both commands complete, run:

   ```bash
   ls ../deliverables/
   ```
   …to confirm your SBOM files were created (sbom_syft_spdx.json and sbom_trivy_cdx.json).

6. Record in your report:
   - How many components each tool reported (Syft vs. Trivy),
   - One difference you notice between the SPDX SBOM and the CycloneDX SBOM (format, fields, component count, etc.), and
   - Screenshots of your terminal output.

## **Part 2: SBOM Vulnerability Analysis**

1. Feed the Syft SBOM into Grype to discover CVEs:

   ```bash
   grype sbom:../deliverables/sbom_syft_spdx.json -o table > ../deliverables/vuln_analysis_grype.txt
   ```
**Syntax Breakdown**:

**grype** Open-source command-line tool used to scans software packages and SBOMs for known vulnerabilities (CVEs) by checking them against vulnerability databases (e.g.,  National Vulnerability Database (NVD) or GitHub Security Advisories)

**sbom:../deliverables/sbom_syft_spdx.json** Tells Grype to use an existing SBOM as its input instead of scanning files directly.

sbom: → The prefix tells Grype the input is an SBOM file, not a filesystem or container

../deliverables/sbom_syft_spdx.json → Path to the SBOM generated earlier by Syft, one directory above the current folder inside deliverables

**-o table** Program option (*-o*) specifying the output format. Here, *table* means results will be shown in a human-readable table format (columns for package, version, vulnerability, severity, etc.)

**> ../deliverables/vuln_analysis_grype.txt** Redirects the command’s output into a text file instead of printing to the terminal:

.. → Move up one directory.

/deliverables/ → Save it in the deliverables folder

*vuln_analysis_grype.txt* → The file name for the vulnerability report

2. In your report, include a table for the top 5 vulnerabilities that includes the following:

   | **CVE** | **Severity** | **Component** | **Version** | **Comment** |
   |----------|---------------|----------------|--------------|--------------|
   | CVE-2023-0286 | High | OpenSSL | 3.0.2 | TLS certificate validation bypass |

3. To preview your results in the terminal before opening the full file, run:

   ```bash
   head -20 ../deliverables/vuln_analysis_grype.txt
   ```
**Syntax Breakdown**:

**head** Linux command used to display the first part of a text file. By default, it shows the first 10 lines, but you can specify a different number using the -n or shorthand -<number> option

**-20** Program option used to specify the number of lines to display — in this case, the first 20 lines of the file

**../deliverables/vuln_analysis_grype.txt** The path and filename of the file you want to preview:

.. → Move up one directory from the current working folder.

/deliverables/ → Go into the deliverables folder.

*vuln_analysis_grype.txt* → The text file containing the vulnerability report generated by Grype.

4. Copy the top 5 rows into your report table. Then select one CVE, locate it in the NVD Database, and summarize its cause or impact in one sentence.

## **Part 3: Deliverables**
**GitHub Submission**:

1. Make sure all deliverables (e.g., SBOM and Grype output files) are saved in the /deliverables folder of your Codespace, committed, and pushed to your forked GitHub repository. Double-check that your repository is public or that the instructor can access it.
2. Submit a **2–3 page report** (PDF) including:

- SBOM generation results  
- Vulnerability analysis (top 5 CVEs or rationale for zero matches)
- Reflection on insights and process  

2. Upload to `/deliverables/` and push to GitHub (use all lowercase filenames as shown below to simplify grading):

```
deliverables/
│
├── sbom_syft_spdx.json
├── sbom_trivy_cdx.json
├── vuln_analysis_grype.txt
├── firstname_lastname_report.pdf
```
**Canvas Submission**:

1. Copy your forked repository URL: Go to your forked repo on GitHub (it should look something like:
   
     `https://github.com/<your-username>/eng298-fa25-mod7-sbom-lab1`
   
   - Copy the URL from your browser’s address bar.

3. Submit the URL in Canvas: Module 7: Assignment: Secure Software Supply Chain with SBOMs  

## **Grading Rubric (20 Points Total)**

| **Criterion** | **Excellent (Full Points)** | **Partial Credit** | **Points** |
|----------------|-----------------------------|--------------------|------------|
| **SBOM Generation** | Both SBOMs (Syft SPDX + Trivy CycloneDX) generated correctly for repo; component count and format differences are discussed; screenshots included. | One SBOM missing, misnamed, or lacking discussion. | 8 |
| **Vulnerability Analysis** Grype scan is run against the Syft SBOM; top 5 CVEs are summarized. One CVE or risk scenario is described using NVD or functional/security reasoning. | Grype not run correctly or limited explanation of results. | 7 |
| **Reflection & Professionalism** | Concise, technically sound reflection linking SBOM, Grype; all required files properly named and pushed to GitHub. | Minor clarity or submission issues. | 5 |
