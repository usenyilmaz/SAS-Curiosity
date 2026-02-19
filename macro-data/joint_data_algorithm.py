import pandas as pd

# Dosyaları yükle (Semicolon ayırıcıya dikkat)
fed = pd.read_csv('FEDFUNDS Formatted.csv', sep=';')
m2 = pd.read_csv('M2SL Formatted.csv', sep=';')
dxy = pd.read_csv('US Dollar Index Historical Data Formatted.csv', sep=';')

# DXY'den sadece Date ve Price sütunlarını tut
dxy = dxy[['Date', 'Price']]
dxy['Price'] = dxy['Price'].str.replace(',', '.').astype(float)
# Price sütununu US Dollar Index olarak adlandır
dxy = dxy.rename(columns={'Price': 'US Dollar Index'})

# Kripto verilerini de (Kaggle'dan indirdiğin) buraya ekle
# Örn: crypto = pd.read_csv('bitcoin.csv')

# Tarihleri datetime formatına çevir ve aylık bazda eşitle
fed['observation_date'] = pd.to_datetime(fed['observation_date'])
m2['observation_date'] = pd.to_datetime(m2['observation_date'])
# DXY tarih formatı farklı (DD.MM.YYYY), bunu da çevirmelisin
dxy['observation_date'] = pd.to_datetime(dxy['Date'], format='%d.%m.%Y')

# Master tabloyu oluştur
master_df = pd.merge(fed, m2, on='observation_date', how='inner')
# DXY'yi de ekle (Date sütununu kaldır, sadece Price ve observation_date kalacak)
dxy = dxy.drop(columns=['Date'])
master_df = pd.merge(master_df, dxy, on='observation_date', how='inner')

# merged.csv olarak kaydet
master_df.to_csv('merged.csv', index=False)