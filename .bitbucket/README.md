# 🧭 Bitbucket Pull Request Templates for Robot Framework

## 📁 Folder Structure

```text
.bitbucket/
├── pull_request_template_base.md
├── pull_request_template.md
└── README.md
```

## 🧩 Usage

1. วางโฟลเดอร์ `.bitbucket/` ไว้ที่ root ของ repo
2. ตอนสร้าง PR → Bitbucket จะดึง `pull_request_template.md` มาเป็น template เริ่มต้น
3. ใน template ที่ได้ ให้เลือก "ประเภทของงาน" และลบ section ที่ไม่เกี่ยวข้องออก
4. ติ๊ก checklist ตามจริง และกรอกรายละเอียดให้ครบถ้วน
5. Reviewer ตรวจและ merge ได้เมื่อ checklist ครบ ✅

## ⚙️ Optional Automation

ถ้ามี Bitbucket Pipelines → เพิ่มขั้นตอน run test เช่น

```yaml
pipelines:
  pull-requests:
    "**":
      - step:
          name: "Run Robot Tests"
          image: python:3.11
          script:
            - pip install -r requirements.txt
            - robot --outputdir results tests/
```

เปิด “Merge Check” เพื่อให้ merge ได้เฉพาะเมื่อ test ผ่านทั้งหมด

> Repository settings → Merge checks → ✅ Require successful build before merging
