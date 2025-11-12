# 🤖 Automation Test Pull Request

## 🎯 ประเภทของงาน (เลือกอย่างน้อย 1 อย่าง)

- [ ] New Testcase
- [ ] New Keyword
- [ ] New Feature
- [ ] Bug Fix
- [ ] Refactor
- [ ] Set Base Structure (just for first PR)

---

## 📝 รายละเอียดโดยรวม

> สรุปภาพรวมของ PR นี้

---

### 🧱 Base Structure Setup PR Checklist (just for first PR)

#### 🧩 Project Setup

- [ ] สร้างโครงสร้างโฟลเดอร์ครบ (`testcases/`, `resources/`, `keywords/`)
- [ ] ตั้งค่าไฟล์หลัก: `.gitignore`, `requirements.txt`, `pyproject.toml`, `README.md`
- [ ] สร้างไฟล์ตั้งค่า `resources/settings/settings.yaml`
- [ ] ติดตั้ง dependency จาก `requirements.txt` และ `rfbrowser init`
- [ ] Commit message อธิบาย setup ชัดเจน

#### 📎 Attachment

- [ ] Link to Automate Plan Document
- [ ] อัปเดต Automate Plan Document
- [ ] แนบ Screenshot Structure Project Setup

### 🧪 กรณีเพิ่ม Testcase ใหม่ (ถ้ามี)

- [ ] Testcase name & documentation ครบ
- [ ] ระบุ Preconditions / Postconditions
- [ ] ใช้ keyword เดิมจาก resource (ไม่เขียนซ้ำ)
- [ ] Dryrun ผ่านและแนบผล log/report
- [ ] Expected result ตรงตาม plan
- [ ] ไม่มีผลกระทบกับ testcase อื่น
- [ ] Capture screenshot ตอน fail
- [ ] อัปเดต automate plan / testcase tracking sheet

### 🧩 กรณีเพิ่ม Keyword ใหม่ (ถ้ามี)

- [ ] Keyword name สื่อความหมายและตรงตาม convention
- [ ] มี Documentation / argument description ครบ
- [ ] ไม่มี duplicate keyword กับ resource อื่น
- [ ] ใช้ reusable logic (หลีกเลี่ยงการ hard-code)
- [ ] ผ่าน dryrun ของ testcase ที่เรียกใช้ keyword นี้
- [ ] อัปเดต resource mapping / changelog แล้ว

### ✨ กรณีเพิ่ม Feature ใหม่ (ถ้ามี)

- [ ] ระบุ Feature / Task ที่เกี่ยวข้อง (จากไฟล์ Excel)
- [ ] Test flow ครอบคลุม positive และ negative case
- [ ] ใช้ keyword เดิมให้มากที่สุด (reusable)
- [ ] ระบุ Preconditions / Postconditions ครบ
- [ ] Dryrun ผ่านทั้งหมดและแนบ report
- [ ] ไม่มี hard-coded data
- [ ] ใช้ Resource / Variable file ถูกต้อง
- [ ] รองรับ CI/CD pipeline
- [ ] Update README / Test Guide

---

## ✅ Checklist ทั่วไป

> ส่วนนี้สำหรับตรวจสอบคุณภาพโดยรวมของ Script

### Script Quality

- [ ] ไม่มี hard-coded data
- [ ] ใช้ Resource / Variable file ถูกต้อง
- [ ] Keyword naming ชัดเจน
- [ ] ใช้ reusable keyword
- [ ] มี Tag (`smoke`, `regression`, `critical`)

### Execution Validation

- [ ] Dryrun ผ่านทั้งหมด
- [ ] แนบ log & report
- [ ] ไม่มี test fail หรืออธิบายสาเหตุ
- [ ] Regression safe
- [ ] Screenshot ตอน fail ครบ

### Environment & Dependency

- [ ] ใช้ ENV ถูกต้อง (QA/UAT/PROD)
- [ ] ตรวจ dependency ใน `requirements.txt`
- [ ] ไม่มี dependency ใหม่โดยไม่แจ้ง reviewer

### Error Handling & Stability

- [ ] ใช้ wait/retry logic เหมาะสม
- [ ] Handle timeout / flaky test

### Documentation & Maintainability

- [ ] Update README / Test Guide
- [ ] Folder structure ถูกต้อง
- [ ] ไม่มีไฟล์ขยะ (`.log`, `.html`, `cache`)

### Commit & Review Info

- [ ] Commit message ชัดเจน
- [ ] Reviewer ถูกต้อง
- [ ] Checklist ครบก่อน merge

### CI/CD Integration (ถ้ามี)

- [ ] รันผ่าน pipeline ได้
- [ ] มี tag สำหรับเลือก test (`--include smoke`)
- [ ] Log/report เก็บใน artifact
- [ ] ไม่มี secret/token ใน repo

---

## 📎 เอกสารแนบ / ข้อมูลอ้างอิง

- [ ] Link to testcase / keyword documentation
- [ ] แนบ test step
- [ ] Update status ใน automate plan document
- [ ] แนบผล Dryrun
- [ ] แนบผล Result This Case

### Summary
