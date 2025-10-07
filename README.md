# Multimodal AI System for Service Satisfaction Analysis  
**服務業多模態顧客滿意度分析系統**  
> 臉部表情、語音、文字多模態資料，讓現場服務情緒和員工表現量化評分

---

## 🧑‍💼 專案簡介 | Project Overview

這套系統給實體門市用，兩路相機＋麥克風同步錄影錄音。  
自動產出顧客與員工的情緒分數，報表和績效分析一鍵搞定。

- 多模態分析（臉部表情、語音、文字）
- Google Cloud Storage + MySQL 資料同步
- PySide6 + QML 前後端分開，門市端／管理端介面
- 分析、圖表、分數自動回寫資料庫

> 支援 end-to-end pipeline，情緒分數、趨勢、報表都能直接看

---

## 🏆 主要功能 | Key Features

- **即時多模態分析**  
  同時分析臉部表情（DeepFace）、語音（Wav2Vec2 + pyannote.audio）、文字（VADER），完整量化顧客和員工的互動情緒。
- **自動化數據串流與回填**  
  錄影錄音結果自動同步 Google Cloud Storage，分析後分數、趨勢和圖表自動寫回 MySQL，無縫串接管理端介面。
- **端到端一鍵操作**  
  門市端錄製→自動觸發分析→報表回填與 PDF/趨勢查詢，一條龍設計。
- **多端前後分離架構**  
  PySide6 + QML，支援「門市端」錄製和「管理端」多門市集中監控，介面切換彈性。
- **彈性擴展**  
  分析模型（如 Random Forest、BERT、DeepFace）皆可獨立優化與替換。

---

## 📦 目錄結構 | Directory Structure

```text
.
├── analyzer.py                # 多模態分析主程式
├── predict_0.py               # 分數預測（Random Forest）
├── analysis_upload.py         # 分析結果上傳＋資料清理
├── clients.py                 # API 觸發腳本
├── database.py                # MySQL 連線 / SP
├── record_widget.py           # 門市端錄影錄音元件
├── server_home_init.py        # 門市端邏輯
├── admin_home_init.py         # 管理端邏輯
├── main.py                    # 啟動（PySide6 GUI）
├── *.qml                      # QML 視覺介面
├── model/                     # RF 模型
├── audio/, video/             # 暫存音檔/影像
├── charts/, text/, scores/    # 分析結果
├── docs/                      # 文件、流程圖
├── requirements.txt           # 依賴清單
└── .env.example               # 環境變數範本






