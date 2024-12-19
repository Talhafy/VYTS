using System;
using Npgsql;

class HavayoluApp
{
    private static readonly string baglantiDizesi = "Host=localhost;Port=5432;Database=Havayolu;Username=postgres;Password=computer;";

    static void Main(string[] args)
    {
        while (true)
        {
            Console.WriteLine("\nHavayolu Uygulaması:");
            Console.WriteLine("1. Yolcu Ekle");
            Console.WriteLine("2. Yolcu Sil");
            Console.WriteLine("3. Yolcu Güncelle");
            Console.WriteLine("4. Yolcu Ara");
            Console.WriteLine("5. Çıkış");
            Console.Write("Seçiminiz: ");

            int secim;
            if (!int.TryParse(Console.ReadLine(), out secim))
            {
                Console.WriteLine("Geçersiz giriş. Lütfen bir sayı girin.");
                continue;
            }

            switch (secim)
            {
                case 1:
                    YolcuEkle();
                    break;
                case 2:
                    YolcuSil();
                    break;
                case 3:
                    YolcuGuncelle();
                    break;
                case 4:
                    YolcuAra();
                    break;
                case 5:
                    Console.WriteLine("Çıkış yapılıyor...");
                    return;
                default:
                    Console.WriteLine("Geçersiz seçim. Lütfen 1-5 arasında bir değer girin.");
                    break;
            }
        }
    }

    static void YolcuEkle()
    {
        try
        {
            Console.Write("Şehir No: ");
            int sehirNo = int.Parse(Console.ReadLine());

            Console.Write("İsim: ");
            string isim = Console.ReadLine();

            Console.Write("Soyisim: ");
            string soyisim = Console.ReadLine();

            Console.Write("Telefon: ");
            string telefon = Console.ReadLine();

            Console.Write("Mail: ");
            string mail = Console.ReadLine();

            string sql = "INSERT INTO yolcu (sehirno, isim, soyisim, telefon, mail) VALUES (@sehirno, @isim, @soyisim, @telefon, @mail) RETURNING yolcuid;";

            using (NpgsqlConnection baglanti = new NpgsqlConnection(baglantiDizesi))
            {
                baglanti.Open();
                using (NpgsqlCommand komut = new NpgsqlCommand(sql, baglanti))
                {
                    komut.Parameters.AddWithValue("@sehirno", sehirNo);
                    komut.Parameters.AddWithValue("@isim", isim);
                    komut.Parameters.AddWithValue("@soyisim", soyisim);
                    komut.Parameters.AddWithValue("@telefon", telefon);
                    komut.Parameters.AddWithValue("@mail", mail);

                    int yeniYolcuId = (int)komut.ExecuteScalar();
                    Console.WriteLine($"Yolcu başarıyla eklendi. Yolcu ID: {yeniYolcuId}");
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Hata oluştu: {ex.Message}");
        }
    }

    static void YolcuSil()
    {
        try
        {
            Console.Write("Silmek istediğiniz yolcunun ID'sini girin: ");
            int yolcuId = int.Parse(Console.ReadLine());

            string sql = "DELETE FROM yolcu WHERE yolcuid = @yolcuid;";

            using (NpgsqlConnection baglanti = new NpgsqlConnection(baglantiDizesi))
            {
                baglanti.Open();
                using (NpgsqlCommand komut = new NpgsqlCommand(sql, baglanti))
                {
                    komut.Parameters.AddWithValue("@yolcuid", yolcuId);

                    int etkilenenSatirlar = komut.ExecuteNonQuery();
                    if (etkilenenSatirlar > 0)
                    {
                        Console.WriteLine("Yolcu başarıyla silindi.");
                    }
                    else
                    {
                        Console.WriteLine("Belirtilen ID ile yolcu bulunamadı.");
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Hata oluştu: {ex.Message}");
        }
    }

    static void YolcuGuncelle()
    {
        try
        {
            Console.Write("Güncellemek istediğiniz yolcunun ID'sini girin: ");
            int yolcuId = int.Parse(Console.ReadLine());

            Console.Write("Yeni Şehir No: ");
            int yeniSehirNo = int.Parse(Console.ReadLine());

            Console.Write("Yeni İsim: ");
            string yeniIsim = Console.ReadLine();

            Console.Write("Yeni Soyisim: ");
            string yeniSoyisim = Console.ReadLine();

            Console.Write("Yeni Telefon: ");
            string yeniTelefon = Console.ReadLine();

            Console.Write("Yeni Mail: ");
            string yeniMail = Console.ReadLine();

            string sql = "UPDATE yolcu SET sehirno = @sehirno, isim = @isim, soyisim = @soyisim, telefon = @telefon, mail = @mail WHERE yolcuid = @yolcuid;";

            using (NpgsqlConnection baglanti = new NpgsqlConnection(baglantiDizesi))
            {
                baglanti.Open();
                using (NpgsqlCommand komut = new NpgsqlCommand(sql, baglanti))
                {
                    komut.Parameters.AddWithValue("@yolcuid", yolcuId);
                    komut.Parameters.AddWithValue("@sehirno", yeniSehirNo);
                    komut.Parameters.AddWithValue("@isim", yeniIsim);
                    komut.Parameters.AddWithValue("@soyisim", yeniSoyisim);
                    komut.Parameters.AddWithValue("@telefon", yeniTelefon);
                    komut.Parameters.AddWithValue("@mail", yeniMail);

                    int sonuc = komut.ExecuteNonQuery();
                    Console.WriteLine(sonuc > 0 ? "Yolcu başarıyla güncellendi." : "Yolcu güncellenirken hata oluştu.");
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Hata oluştu: {ex.Message}");
        }
    }

    static void YolcuAra()
    {
        try
        {
            Console.Write("Aramak istediğiniz yolcunun ID'sini girin: ");
            int yolcuId = int.Parse(Console.ReadLine());

            string sql = "SELECT * FROM yolcu WHERE yolcuid = @yolcuid;";

            using (NpgsqlConnection baglanti = new NpgsqlConnection(baglantiDizesi))
            {
                baglanti.Open();
                using (NpgsqlCommand komut = new NpgsqlCommand(sql, baglanti))
                {
                    komut.Parameters.AddWithValue("@yolcuid", yolcuId);

                    using (NpgsqlDataReader okuyucu = komut.ExecuteReader())
                    {
                        if (okuyucu.Read())
                        {
                            Console.WriteLine("Yolcu Bilgileri:");
                            Console.WriteLine($"ID: {okuyucu["yolcuid"]}");
                            Console.WriteLine($"Şehir No: {okuyucu["sehirno"]}");
                            Console.WriteLine($"İsim: {okuyucu["isim"]}");
                            Console.WriteLine($"Soyisim: {okuyucu["soyisim"]}");
                            Console.WriteLine($"Telefon: {okuyucu["telefon"]}");
                            Console.WriteLine($"Mail: {okuyucu["mail"]}");
                        }
                        else
                        {
                            Console.WriteLine("Belirtilen ID ile yolcu bulunamadı.");
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Hata oluştu: {ex.Message}");
        }
    }
}
