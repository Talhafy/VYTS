--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2024-12-19 13:35:22

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 257 (class 1255 OID 17770)
-- Name: bilet_fiyat_guncelle(integer, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.bilet_fiyat_guncelle(p_biletid integer, p_yeni_fiyat numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE Bilet
    SET fiyat = p_yeni_fiyat
    WHERE biletID = p_biletID;
END;
$$;


ALTER FUNCTION public.bilet_fiyat_guncelle(p_biletid integer, p_yeni_fiyat numeric) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 18111)
-- Name: ekle_sehir(integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ekle_sehir(p_sehirid integer, p_ulkeno integer, p_sehiradi character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO sehir (sehirid, ulkeno, sehiradi)
    VALUES (p_sehirid, p_ulkeno, p_sehiradi);
END;
$$;


ALTER FUNCTION public.ekle_sehir(p_sehirid integer, p_ulkeno integer, p_sehiradi character varying) OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 17777)
-- Name: rezervasyon_tarih_kontrol(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rezervasyon_tarih_kontrol() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.rezervasyonTarihi >=CURRENT_DATE THEN
        RAISE EXCEPTION 'Yanlış  tarih girdiniz!!';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.rezervasyon_tarih_kontrol() OWNER TO postgres;

--
-- TOC entry 258 (class 1255 OID 17773)
-- Name: telefon_kontrol(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.telefon_kontrol() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF LENGTH(NEW.telefon) <> 10 THEN
        RAISE EXCEPTION 'Telefon numarası 10 haneli olmalıdır.';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.telefon_kontrol() OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 17771)
-- Name: toplam_rezervasyon(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.toplam_rezervasyon() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    toplam INT;
BEGIN
    SELECT COUNT(*) INTO toplam FROM Rezervasyon;
    RETURN toplam;
END;
$$;


ALTER FUNCTION public.toplam_rezervasyon() OWNER TO postgres;

--
-- TOC entry 261 (class 1255 OID 17779)
-- Name: ucak_kapasite_kontrol(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ucak_kapasite_kontrol() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.yolcuKapasitesi <= 0 THEN
        RAISE EXCEPTION 'Uçak kapasitesi 0 veya negatif olamaz.';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.ucak_kapasite_kontrol() OWNER TO postgres;

--
-- TOC entry 259 (class 1255 OID 17775)
-- Name: ucus_saat_kontrol(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ucus_saat_kontrol() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.kalkisSaati >= NEW.varisSaati THEN
        RAISE EXCEPTION 'Kalkış saati, varış saatinden önce olmalıdır!';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.ucus_saat_kontrol() OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 18113)
-- Name: yolcu_ara(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.yolcu_ara(p_yolcuid integer) RETURNS TABLE(yolcuid integer, sehirno integer, isim character varying, soyisim character varying, telefon character varying, mail character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        yolcu.yolcuid, yolcu.sehirno, yolcu.isim, yolcu.soyisim, yolcu.telefon, yolcu.mail
    FROM yolcu AS yolcu
    WHERE yolcu.yolcuid = p_yolcuid;
END;
$$;


ALTER FUNCTION public.yolcu_ara(p_yolcuid integer) OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 18103)
-- Name: yolcu_arsivle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.yolcu_arsivle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   INSERT INTO "eskiyolcular"("eskiyolcuid", "sehirno", "isim", "soyisim", "telefon", "mail")
   VALUES(OLD."yolcuid", OLD."sehirno", OLD."isim", OLD."soyisim", OLD."telefon", OLD."mail");

   RETURN OLD; 
END;
$$;


ALTER FUNCTION public.yolcu_arsivle() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 240 (class 1259 OID 17631)
-- Name: bilet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bilet (
    biletid integer NOT NULL,
    ucussinifi character varying(50),
    fiyat numeric
);


ALTER TABLE public.bilet OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 17630)
-- Name: bilet_biletid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bilet_biletid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bilet_biletid_seq OWNER TO postgres;

--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 239
-- Name: bilet_biletid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bilet_biletid_seq OWNED BY public.bilet.biletid;


--
-- TOC entry 226 (class 1259 OID 17527)
-- Name: eskiyolcular; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eskiyolcular (
    eskiyolcuid integer NOT NULL,
    sehirno integer,
    isim character varying(100),
    soyisim character varying(100),
    telefon character varying(20),
    mail character varying(100)
);


ALTER TABLE public.eskiyolcular OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17526)
-- Name: eskiyolcular_eskiyolcuid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.eskiyolcular_eskiyolcuid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eskiyolcular_eskiyolcuid_seq OWNER TO postgres;

--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 225
-- Name: eskiyolcular_eskiyolcuid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.eskiyolcular_eskiyolcuid_seq OWNED BY public.eskiyolcular.eskiyolcuid;


--
-- TOC entry 242 (class 1259 OID 17640)
-- Name: hangar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hangar (
    hangarid integer NOT NULL,
    limanno integer,
    metrekare integer
);


ALTER TABLE public.hangar OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 17639)
-- Name: hangar_hangarid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hangar_hangarid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hangar_hangarid_seq OWNER TO postgres;

--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 241
-- Name: hangar_hangarid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hangar_hangarid_seq OWNED BY public.hangar.hangarid;


--
-- TOC entry 244 (class 1259 OID 17652)
-- Name: hangardakiucak; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hangardakiucak (
    hulid integer NOT NULL,
    ucakno integer,
    hangarno integer,
    ucaksayisi integer
);


ALTER TABLE public.hangardakiucak OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 17651)
-- Name: hangardakiucak_hulid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hangardakiucak_hulid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hangardakiucak_hulid_seq OWNER TO postgres;

--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 243
-- Name: hangardakiucak_hulid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hangardakiucak_hulid_seq OWNED BY public.hangardakiucak.hulid;


--
-- TOC entry 228 (class 1259 OID 17539)
-- Name: havalimani; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.havalimani (
    limanid integer NOT NULL,
    sehirno integer,
    havalimaniadi character varying(100)
);


ALTER TABLE public.havalimani OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17538)
-- Name: havalimani_limanid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.havalimani_limanid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.havalimani_limanid_seq OWNER TO postgres;

--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 227
-- Name: havalimani_limanid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.havalimani_limanid_seq OWNED BY public.havalimani.limanid;


--
-- TOC entry 222 (class 1259 OID 17503)
-- Name: havayolufirmasi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.havayolufirmasi (
    havayoluid integer NOT NULL,
    sehirno integer,
    firmaadi character varying(100) NOT NULL
);


ALTER TABLE public.havayolufirmasi OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 17502)
-- Name: havayolufirmasi_havayoluid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.havayolufirmasi_havayoluid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.havayolufirmasi_havayoluid_seq OWNER TO postgres;

--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 221
-- Name: havayolufirmasi_havayoluid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.havayolufirmasi_havayoluid_seq OWNED BY public.havayolufirmasi.havayoluid;


--
-- TOC entry 230 (class 1259 OID 17551)
-- Name: inisliman; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inisliman (
    inisid integer NOT NULL,
    limanno integer
);


ALTER TABLE public.inisliman OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17550)
-- Name: inisliman_inisid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inisliman_inisid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inisliman_inisid_seq OWNER TO postgres;

--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 229
-- Name: inisliman_inisid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inisliman_inisid_seq OWNED BY public.inisliman.inisid;


--
-- TOC entry 254 (class 1259 OID 17736)
-- Name: kabinmemuru; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kabinmemuru (
    kmid integer NOT NULL,
    personelno integer,
    ucakno integer,
    maas money
);


ALTER TABLE public.kabinmemuru OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 17735)
-- Name: kabinmemuru_kmid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kabinmemuru_kmid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kabinmemuru_kmid_seq OWNER TO postgres;

--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 253
-- Name: kabinmemuru_kmid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kabinmemuru_kmid_seq OWNED BY public.kabinmemuru.kmid;


--
-- TOC entry 232 (class 1259 OID 17563)
-- Name: kalkisliman; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kalkisliman (
    kalkisid integer NOT NULL,
    limanno integer
);


ALTER TABLE public.kalkisliman OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17562)
-- Name: kalkisliman_kalkisid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kalkisliman_kalkisid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kalkisliman_kalkisid_seq OWNER TO postgres;

--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 231
-- Name: kalkisliman_kalkisid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kalkisliman_kalkisid_seq OWNED BY public.kalkisliman.kalkisid;


--
-- TOC entry 248 (class 1259 OID 17686)
-- Name: personel; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.personel (
    personelid integer NOT NULL,
    firmano integer,
    adi character varying(100),
    soyadi character varying(100),
    telefon character varying(20),
    isebaslamatarihi date
);


ALTER TABLE public.personel OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 17685)
-- Name: personel_personelid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.personel_personelid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.personel_personelid_seq OWNER TO postgres;

--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 247
-- Name: personel_personelid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.personel_personelid_seq OWNED BY public.personel.personelid;


--
-- TOC entry 252 (class 1259 OID 17717)
-- Name: pilot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pilot (
    pilotid integer NOT NULL,
    personelno integer,
    ucakno integer,
    maas money
);


ALTER TABLE public.pilot OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 17716)
-- Name: pilot_pilotid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pilot_pilotid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pilot_pilotid_seq OWNER TO postgres;

--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 251
-- Name: pilot_pilotid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pilot_pilotid_seq OWNED BY public.pilot.pilotid;


--
-- TOC entry 238 (class 1259 OID 17614)
-- Name: rezervasyon; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rezervasyon (
    rezid integer NOT NULL,
    yolcuno integer,
    ucusno integer,
    biletno integer,
    koltuknumarasi character varying(10),
    rezervasyontarihi date,
    ucustarihi date
);


ALTER TABLE public.rezervasyon OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17613)
-- Name: rezervasyon_rezid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rezervasyon_rezid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rezervasyon_rezid_seq OWNER TO postgres;

--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 237
-- Name: rezervasyon_rezid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rezervasyon_rezid_seq OWNED BY public.rezervasyon.rezid;


--
-- TOC entry 220 (class 1259 OID 17491)
-- Name: sehir; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sehir (
    sehirid integer NOT NULL,
    ulkeno integer,
    sehiradi character varying(100) NOT NULL
);


ALTER TABLE public.sehir OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 17490)
-- Name: sehir_sehirid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sehir_sehirid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sehir_sehirid_seq OWNER TO postgres;

--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 219
-- Name: sehir_sehirid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sehir_sehirid_seq OWNED BY public.sehir.sehirid;


--
-- TOC entry 234 (class 1259 OID 17575)
-- Name: ucak; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ucak (
    ucakid integer NOT NULL,
    firmano integer,
    yolcukapasitesi integer,
    ucakmodeli character varying(100),
    kullanimomru integer
);


ALTER TABLE public.ucak OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17574)
-- Name: ucak_ucakid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ucak_ucakid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ucak_ucakid_seq OWNER TO postgres;

--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 233
-- Name: ucak_ucakid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ucak_ucakid_seq OWNED BY public.ucak.ucakid;


--
-- TOC entry 236 (class 1259 OID 17587)
-- Name: ucus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ucus (
    ucusid integer NOT NULL,
    firmano integer,
    kalkislimanno integer,
    inislimanno integer,
    ucakno integer,
    kalkissaati timestamp without time zone,
    varissaati timestamp without time zone
);


ALTER TABLE public.ucus OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17586)
-- Name: ucus_ucusid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ucus_ucusid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ucus_ucusid_seq OWNER TO postgres;

--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 235
-- Name: ucus_ucusid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ucus_ucusid_seq OWNED BY public.ucus.ucusid;


--
-- TOC entry 218 (class 1259 OID 17484)
-- Name: ulke; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ulke (
    ulkeid integer NOT NULL,
    ulkeadi character varying(100) NOT NULL
);


ALTER TABLE public.ulke OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 17483)
-- Name: ulke_ulkeid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ulke_ulkeid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ulke_ulkeid_seq OWNER TO postgres;

--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 217
-- Name: ulke_ulkeid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ulke_ulkeid_seq OWNED BY public.ulke.ulkeid;


--
-- TOC entry 246 (class 1259 OID 17669)
-- Name: yedekparca; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.yedekparca (
    yedekid integer NOT NULL,
    ucakno integer,
    limanno integer,
    parcasayisi integer
);


ALTER TABLE public.yedekparca OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 17668)
-- Name: yedekparca_yedekid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.yedekparca_yedekid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.yedekparca_yedekid_seq OWNER TO postgres;

--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 245
-- Name: yedekparca_yedekid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.yedekparca_yedekid_seq OWNED BY public.yedekparca.yedekid;


--
-- TOC entry 250 (class 1259 OID 17698)
-- Name: yerhizmetleri; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.yerhizmetleri (
    yhid integer NOT NULL,
    personelno integer,
    limanno integer,
    maas money
);


ALTER TABLE public.yerhizmetleri OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 17697)
-- Name: yerhizmetleri_yhid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.yerhizmetleri_yhid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.yerhizmetleri_yhid_seq OWNER TO postgres;

--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 249
-- Name: yerhizmetleri_yhid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.yerhizmetleri_yhid_seq OWNED BY public.yerhizmetleri.yhid;


--
-- TOC entry 224 (class 1259 OID 17515)
-- Name: yolcu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.yolcu (
    yolcuid integer NOT NULL,
    sehirno integer,
    isim character varying(100),
    soyisim character varying(100),
    telefon character varying(20),
    mail character varying(100)
);


ALTER TABLE public.yolcu OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 17514)
-- Name: yolcu_yolcuid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.yolcu_yolcuid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.yolcu_yolcuid_seq OWNER TO postgres;

--
-- TOC entry 5146 (class 0 OID 0)
-- Dependencies: 223
-- Name: yolcu_yolcuid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.yolcu_yolcuid_seq OWNED BY public.yolcu.yolcuid;


--
-- TOC entry 256 (class 1259 OID 17755)
-- Name: yonetim; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.yonetim (
    yonetimid integer NOT NULL,
    personelno integer,
    maas money
);


ALTER TABLE public.yonetim OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 17754)
-- Name: yonetim_yonetimid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.yonetim_yonetimid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.yonetim_yonetimid_seq OWNER TO postgres;

--
-- TOC entry 5147 (class 0 OID 0)
-- Dependencies: 255
-- Name: yonetim_yonetimid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.yonetim_yonetimid_seq OWNED BY public.yonetim.yonetimid;


--
-- TOC entry 4857 (class 2604 OID 17634)
-- Name: bilet biletid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bilet ALTER COLUMN biletid SET DEFAULT nextval('public.bilet_biletid_seq'::regclass);


--
-- TOC entry 4850 (class 2604 OID 17530)
-- Name: eskiyolcular eskiyolcuid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eskiyolcular ALTER COLUMN eskiyolcuid SET DEFAULT nextval('public.eskiyolcular_eskiyolcuid_seq'::regclass);


--
-- TOC entry 4858 (class 2604 OID 17643)
-- Name: hangar hangarid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hangar ALTER COLUMN hangarid SET DEFAULT nextval('public.hangar_hangarid_seq'::regclass);


--
-- TOC entry 4859 (class 2604 OID 17655)
-- Name: hangardakiucak hulid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hangardakiucak ALTER COLUMN hulid SET DEFAULT nextval('public.hangardakiucak_hulid_seq'::regclass);


--
-- TOC entry 4851 (class 2604 OID 17542)
-- Name: havalimani limanid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.havalimani ALTER COLUMN limanid SET DEFAULT nextval('public.havalimani_limanid_seq'::regclass);


--
-- TOC entry 4848 (class 2604 OID 17506)
-- Name: havayolufirmasi havayoluid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.havayolufirmasi ALTER COLUMN havayoluid SET DEFAULT nextval('public.havayolufirmasi_havayoluid_seq'::regclass);


--
-- TOC entry 4852 (class 2604 OID 17554)
-- Name: inisliman inisid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inisliman ALTER COLUMN inisid SET DEFAULT nextval('public.inisliman_inisid_seq'::regclass);


--
-- TOC entry 4864 (class 2604 OID 17739)
-- Name: kabinmemuru kmid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kabinmemuru ALTER COLUMN kmid SET DEFAULT nextval('public.kabinmemuru_kmid_seq'::regclass);


--
-- TOC entry 4853 (class 2604 OID 17566)
-- Name: kalkisliman kalkisid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kalkisliman ALTER COLUMN kalkisid SET DEFAULT nextval('public.kalkisliman_kalkisid_seq'::regclass);


--
-- TOC entry 4861 (class 2604 OID 17689)
-- Name: personel personelid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel ALTER COLUMN personelid SET DEFAULT nextval('public.personel_personelid_seq'::regclass);


--
-- TOC entry 4863 (class 2604 OID 17720)
-- Name: pilot pilotid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pilot ALTER COLUMN pilotid SET DEFAULT nextval('public.pilot_pilotid_seq'::regclass);


--
-- TOC entry 4856 (class 2604 OID 17617)
-- Name: rezervasyon rezid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon ALTER COLUMN rezid SET DEFAULT nextval('public.rezervasyon_rezid_seq'::regclass);


--
-- TOC entry 4847 (class 2604 OID 17494)
-- Name: sehir sehirid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sehir ALTER COLUMN sehirid SET DEFAULT nextval('public.sehir_sehirid_seq'::regclass);


--
-- TOC entry 4854 (class 2604 OID 17578)
-- Name: ucak ucakid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ucak ALTER COLUMN ucakid SET DEFAULT nextval('public.ucak_ucakid_seq'::regclass);


--
-- TOC entry 4855 (class 2604 OID 17590)
-- Name: ucus ucusid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ucus ALTER COLUMN ucusid SET DEFAULT nextval('public.ucus_ucusid_seq'::regclass);


--
-- TOC entry 4846 (class 2604 OID 17487)
-- Name: ulke ulkeid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ulke ALTER COLUMN ulkeid SET DEFAULT nextval('public.ulke_ulkeid_seq'::regclass);


--
-- TOC entry 4860 (class 2604 OID 17672)
-- Name: yedekparca yedekid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yedekparca ALTER COLUMN yedekid SET DEFAULT nextval('public.yedekparca_yedekid_seq'::regclass);


--
-- TOC entry 4862 (class 2604 OID 17701)
-- Name: yerhizmetleri yhid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yerhizmetleri ALTER COLUMN yhid SET DEFAULT nextval('public.yerhizmetleri_yhid_seq'::regclass);


--
-- TOC entry 4849 (class 2604 OID 17518)
-- Name: yolcu yolcuid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yolcu ALTER COLUMN yolcuid SET DEFAULT nextval('public.yolcu_yolcuid_seq'::regclass);


--
-- TOC entry 4865 (class 2604 OID 17758)
-- Name: yonetim yonetimid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetim ALTER COLUMN yonetimid SET DEFAULT nextval('public.yonetim_yonetimid_seq'::regclass);


--
-- TOC entry 5106 (class 0 OID 17631)
-- Dependencies: 240
-- Data for Name: bilet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bilet (biletid, ucussinifi, fiyat) FROM stdin;
2	Business	2500
1	Economy	1700
\.


--
-- TOC entry 5092 (class 0 OID 17527)
-- Dependencies: 226
-- Data for Name: eskiyolcular; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.eskiyolcular (eskiyolcuid, sehirno, isim, soyisim, telefon, mail) FROM stdin;
\.


--
-- TOC entry 5108 (class 0 OID 17640)
-- Dependencies: 242
-- Data for Name: hangar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hangar (hangarid, limanno, metrekare) FROM stdin;
1	1	30000
2	2	45000
3	3	50000
\.


--
-- TOC entry 5110 (class 0 OID 17652)
-- Dependencies: 244
-- Data for Name: hangardakiucak; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hangardakiucak (hulid, ucakno, hangarno, ucaksayisi) FROM stdin;
\.


--
-- TOC entry 5094 (class 0 OID 17539)
-- Dependencies: 228
-- Data for Name: havalimani; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.havalimani (limanid, sehirno, havalimaniadi) FROM stdin;
1	6	Esenboğa
2	34	Sabiha Gökçen
3	100	Düsseldorf 
\.


--
-- TOC entry 5088 (class 0 OID 17503)
-- Dependencies: 222
-- Data for Name: havayolufirmasi; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.havayolufirmasi (havayoluid, sehirno, firmaadi) FROM stdin;
1	34	THY
2	34	A JET
3	34	PEGASUS
4	8	SUN EXPRESS
\.


--
-- TOC entry 5096 (class 0 OID 17551)
-- Dependencies: 230
-- Data for Name: inisliman; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inisliman (inisid, limanno) FROM stdin;
2	1
1	2
3	3
\.


--
-- TOC entry 5120 (class 0 OID 17736)
-- Dependencies: 254
-- Data for Name: kabinmemuru; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kabinmemuru (kmid, personelno, ucakno, maas) FROM stdin;
2	12	4	$9,000.00
4	8	2	$8,000.00
3	4	3	$12,000.00
1	13	1	$10,000.00
\.


--
-- TOC entry 5098 (class 0 OID 17563)
-- Dependencies: 232
-- Data for Name: kalkisliman; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kalkisliman (kalkisid, limanno) FROM stdin;
1	1
2	1
3	2
\.


--
-- TOC entry 5114 (class 0 OID 17686)
-- Dependencies: 248
-- Data for Name: personel; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.personel (personelid, firmano, adi, soyadi, telefon, isebaslamatarihi) FROM stdin;
11	1	Murat	Yücedağ	5588953092	2020-12-16
9	1	Nisa	Türkoğlu	5538376430	2023-02-04
8	2	Kerem	Köse	5354142678	2015-03-08
7	2	Baran	Yıldırım	5432345678	2020-02-20
6	2	Ahsen	Çelik	5456752550	2016-06-17
5	3	Ali	Örnek	5356686430	2018-05-19
4	3	Celal	Çeken	5537654890	2021-12-01
3	3	İsmail	Çetin	5456756784	2021-01-30
2	4	Talha	Yıldırım	5556879802	2024-04-30
1	4	Merve	Kaya	5537565438	2023-09-21
12	4	Mete	Teke	5654678990	2024-05-02
13	1	Zahid	Arıkan	5453456789	2018-03-18
10	\N	Metin	Tekin	5547888965	2019-10-25
14	\N	Beyza	Ulusoy	5342573212	2024-10-01
15	\N	Merve	Bayar	5467648375	2021-05-10
\.


--
-- TOC entry 5118 (class 0 OID 17717)
-- Dependencies: 252
-- Data for Name: pilot; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.pilot (pilotid, personelno, ucakno, maas) FROM stdin;
3	3	3	$1,500,000.00
2	7	2	$16,000.00
1	9	1	$20,000.00
4	2	4	$17,500.00
\.


--
-- TOC entry 5104 (class 0 OID 17614)
-- Dependencies: 238
-- Data for Name: rezervasyon; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rezervasyon (rezid, yolcuno, ucusno, biletno, koltuknumarasi, rezervasyontarihi, ucustarihi) FROM stdin;
2	2	3	1	26A	2024-11-17	2024-12-19
1	1	1	1	13C	2024-12-10	2024-12-19
\.


--
-- TOC entry 5086 (class 0 OID 17491)
-- Dependencies: 220
-- Data for Name: sehir; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sehir (sehirid, ulkeno, sehiradi) FROM stdin;
1	1	Adana
6	1	Ankara
27	1	Gaziantep
34	1	İstanbul
54	1	Sakarya
101	3	Londra
100	2	Düsseldorf
102	4	Paris
103	5	Amsterdam
105	7	Tahran
8	1	Antalya
7	1	Antalya
\.


--
-- TOC entry 5100 (class 0 OID 17575)
-- Dependencies: 234
-- Data for Name: ucak; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ucak (ucakid, firmano, yolcukapasitesi, ucakmodeli, kullanimomru) FROM stdin;
1	4	260	Boeing 737-800 NG	20
4	2	200	Airbus A320neo	25
3	3	250	Boeing 737-800	20
2	1	260	Airbus A330-300	25
\.


--
-- TOC entry 5102 (class 0 OID 17587)
-- Dependencies: 236
-- Data for Name: ucus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ucus (ucusid, firmano, kalkislimanno, inislimanno, ucakno, kalkissaati, varissaati) FROM stdin;
1	2	1	3	1	2024-12-19 14:06:00	2024-12-19 14:36:36
2	1	2	3	4	2024-12-19 08:59:00	2024-12-19 14:13:41
3	4	3	1	2	2024-12-19 12:45:00	2024-12-19 15:25:25
\.


--
-- TOC entry 5084 (class 0 OID 17484)
-- Dependencies: 218
-- Data for Name: ulke; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ulke (ulkeid, ulkeadi) FROM stdin;
1	Türkiye
2	Almanya
3	İngiltere
4	Fransa
5	Hollanda
6	İspanya
7	İran
8	Kanada
9	Rusya
10	Mısır
\.


--
-- TOC entry 5112 (class 0 OID 17669)
-- Dependencies: 246
-- Data for Name: yedekparca; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.yedekparca (yedekid, ucakno, limanno, parcasayisi) FROM stdin;
1	2	1	1000
2	1	1	2000
3	2	3	1500
4	3	2	3000
5	4	1	1000
6	3	2	100
7	1	3	500
8	4	2	1500
\.


--
-- TOC entry 5116 (class 0 OID 17698)
-- Dependencies: 250
-- Data for Name: yerhizmetleri; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.yerhizmetleri (yhid, personelno, limanno, maas) FROM stdin;
1	10	1	$5,000.00
2	14	2	$3,500.00
3	15	3	$4,500.00
\.


--
-- TOC entry 5090 (class 0 OID 17515)
-- Dependencies: 224
-- Data for Name: yolcu; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.yolcu (yolcuid, sehirno, isim, soyisim, telefon, mail) FROM stdin;
1	6	Talha	Yıldırım	5538376430	talha.yildirim177@gmail.com
2	54	Celal	Ceken	5556788945	celalceken@sakarya.edu.tr
\.


--
-- TOC entry 5122 (class 0 OID 17755)
-- Dependencies: 256
-- Data for Name: yonetim; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.yonetim (yonetimid, personelno, maas) FROM stdin;
1	1	$10,000.00
\.


--
-- TOC entry 5148 (class 0 OID 0)
-- Dependencies: 239
-- Name: bilet_biletid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bilet_biletid_seq', 1, false);


--
-- TOC entry 5149 (class 0 OID 0)
-- Dependencies: 225
-- Name: eskiyolcular_eskiyolcuid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eskiyolcular_eskiyolcuid_seq', 1, false);


--
-- TOC entry 5150 (class 0 OID 0)
-- Dependencies: 241
-- Name: hangar_hangarid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hangar_hangarid_seq', 1, false);


--
-- TOC entry 5151 (class 0 OID 0)
-- Dependencies: 243
-- Name: hangardakiucak_hulid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hangardakiucak_hulid_seq', 1, false);


--
-- TOC entry 5152 (class 0 OID 0)
-- Dependencies: 227
-- Name: havalimani_limanid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.havalimani_limanid_seq', 1, false);


--
-- TOC entry 5153 (class 0 OID 0)
-- Dependencies: 221
-- Name: havayolufirmasi_havayoluid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.havayolufirmasi_havayoluid_seq', 1, false);


--
-- TOC entry 5154 (class 0 OID 0)
-- Dependencies: 229
-- Name: inisliman_inisid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inisliman_inisid_seq', 1, false);


--
-- TOC entry 5155 (class 0 OID 0)
-- Dependencies: 253
-- Name: kabinmemuru_kmid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kabinmemuru_kmid_seq', 1, false);


--
-- TOC entry 5156 (class 0 OID 0)
-- Dependencies: 231
-- Name: kalkisliman_kalkisid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kalkisliman_kalkisid_seq', 1, false);


--
-- TOC entry 5157 (class 0 OID 0)
-- Dependencies: 247
-- Name: personel_personelid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.personel_personelid_seq', 1, false);


--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 251
-- Name: pilot_pilotid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.pilot_pilotid_seq', 1, false);


--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 237
-- Name: rezervasyon_rezid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rezervasyon_rezid_seq', 1, false);


--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 219
-- Name: sehir_sehirid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sehir_sehirid_seq', 1, false);


--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 233
-- Name: ucak_ucakid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ucak_ucakid_seq', 1, false);


--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 235
-- Name: ucus_ucusid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ucus_ucusid_seq', 1, false);


--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 217
-- Name: ulke_ulkeid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ulke_ulkeid_seq', 1, false);


--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 245
-- Name: yedekparca_yedekid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.yedekparca_yedekid_seq', 1, false);


--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 249
-- Name: yerhizmetleri_yhid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.yerhizmetleri_yhid_seq', 1, false);


--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 223
-- Name: yolcu_yolcuid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.yolcu_yolcuid_seq', 1, true);


--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 255
-- Name: yonetim_yonetimid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.yonetim_yonetimid_seq', 1, false);


--
-- TOC entry 4889 (class 2606 OID 17638)
-- Name: bilet bilet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bilet
    ADD CONSTRAINT bilet_pkey PRIMARY KEY (biletid);


--
-- TOC entry 4875 (class 2606 OID 17532)
-- Name: eskiyolcular eskiyolcular_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eskiyolcular
    ADD CONSTRAINT eskiyolcular_pkey PRIMARY KEY (eskiyolcuid);


--
-- TOC entry 4891 (class 2606 OID 17645)
-- Name: hangar hangar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hangar
    ADD CONSTRAINT hangar_pkey PRIMARY KEY (hangarid);


--
-- TOC entry 4893 (class 2606 OID 17657)
-- Name: hangardakiucak hangardakiucak_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hangardakiucak
    ADD CONSTRAINT hangardakiucak_pkey PRIMARY KEY (hulid);


--
-- TOC entry 4877 (class 2606 OID 17544)
-- Name: havalimani havalimani_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.havalimani
    ADD CONSTRAINT havalimani_pkey PRIMARY KEY (limanid);


--
-- TOC entry 4871 (class 2606 OID 17508)
-- Name: havayolufirmasi havayolufirmasi_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.havayolufirmasi
    ADD CONSTRAINT havayolufirmasi_pkey PRIMARY KEY (havayoluid);


--
-- TOC entry 4879 (class 2606 OID 17556)
-- Name: inisliman inisliman_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inisliman
    ADD CONSTRAINT inisliman_pkey PRIMARY KEY (inisid);


--
-- TOC entry 4903 (class 2606 OID 17743)
-- Name: kabinmemuru kabinmemuru_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kabinmemuru
    ADD CONSTRAINT kabinmemuru_pkey PRIMARY KEY (kmid);


--
-- TOC entry 4881 (class 2606 OID 17568)
-- Name: kalkisliman kalkisliman_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kalkisliman
    ADD CONSTRAINT kalkisliman_pkey PRIMARY KEY (kalkisid);


--
-- TOC entry 4897 (class 2606 OID 17691)
-- Name: personel personel_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_pkey PRIMARY KEY (personelid);


--
-- TOC entry 4901 (class 2606 OID 17724)
-- Name: pilot pilot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pilot
    ADD CONSTRAINT pilot_pkey PRIMARY KEY (pilotid);


--
-- TOC entry 4887 (class 2606 OID 17619)
-- Name: rezervasyon rezervasyon_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon
    ADD CONSTRAINT rezervasyon_pkey PRIMARY KEY (rezid);


--
-- TOC entry 4869 (class 2606 OID 17496)
-- Name: sehir sehir_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sehir
    ADD CONSTRAINT sehir_pkey PRIMARY KEY (sehirid);


--
-- TOC entry 4883 (class 2606 OID 17580)
-- Name: ucak ucak_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ucak
    ADD CONSTRAINT ucak_pkey PRIMARY KEY (ucakid);


--
-- TOC entry 4885 (class 2606 OID 17592)
-- Name: ucus ucus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ucus
    ADD CONSTRAINT ucus_pkey PRIMARY KEY (ucusid);


--
-- TOC entry 4867 (class 2606 OID 17489)
-- Name: ulke ulke_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ulke
    ADD CONSTRAINT ulke_pkey PRIMARY KEY (ulkeid);


--
-- TOC entry 4895 (class 2606 OID 17674)
-- Name: yedekparca yedekparca_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yedekparca
    ADD CONSTRAINT yedekparca_pkey PRIMARY KEY (yedekid);


--
-- TOC entry 4899 (class 2606 OID 17705)
-- Name: yerhizmetleri yerhizmetleri_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yerhizmetleri
    ADD CONSTRAINT yerhizmetleri_pkey PRIMARY KEY (yhid);


--
-- TOC entry 4873 (class 2606 OID 17520)
-- Name: yolcu yolcu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yolcu
    ADD CONSTRAINT yolcu_pkey PRIMARY KEY (yolcuid);


--
-- TOC entry 4905 (class 2606 OID 17762)
-- Name: yonetim yonetim_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetim
    ADD CONSTRAINT yonetim_pkey PRIMARY KEY (yonetimid);


--
-- TOC entry 4937 (class 2620 OID 17778)
-- Name: rezervasyon trigger_rezervasyon_tarih; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_rezervasyon_tarih BEFORE INSERT OR UPDATE ON public.rezervasyon FOR EACH ROW EXECUTE FUNCTION public.rezervasyon_tarih_kontrol();


--
-- TOC entry 4933 (class 2620 OID 17774)
-- Name: yolcu trigger_telefon_kontrol; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_telefon_kontrol BEFORE INSERT OR UPDATE ON public.yolcu FOR EACH ROW EXECUTE FUNCTION public.telefon_kontrol();


--
-- TOC entry 4935 (class 2620 OID 17780)
-- Name: ucak trigger_ucak_kapasite_kontrol; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_ucak_kapasite_kontrol BEFORE INSERT OR UPDATE ON public.ucak FOR EACH ROW EXECUTE FUNCTION public.ucak_kapasite_kontrol();


--
-- TOC entry 4936 (class 2620 OID 17776)
-- Name: ucus trigger_ucus_saat_kontrol; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_ucus_saat_kontrol BEFORE INSERT OR UPDATE ON public.ucus FOR EACH ROW EXECUTE FUNCTION public.ucus_saat_kontrol();


--
-- TOC entry 4934 (class 2620 OID 18104)
-- Name: yolcu trigger_yolcu_arsivle; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_yolcu_arsivle AFTER DELETE ON public.yolcu FOR EACH ROW EXECUTE FUNCTION public.yolcu_arsivle();


--
-- TOC entry 4909 (class 2606 OID 17533)
-- Name: eskiyolcular eskiyolcular_sehirno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eskiyolcular
    ADD CONSTRAINT eskiyolcular_sehirno_fkey FOREIGN KEY (sehirno) REFERENCES public.sehir(sehirid);


--
-- TOC entry 4920 (class 2606 OID 17646)
-- Name: hangar hangar_limanno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hangar
    ADD CONSTRAINT hangar_limanno_fkey FOREIGN KEY (limanno) REFERENCES public.havalimani(limanid);


--
-- TOC entry 4921 (class 2606 OID 17663)
-- Name: hangardakiucak hangardakiucak_hangarno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hangardakiucak
    ADD CONSTRAINT hangardakiucak_hangarno_fkey FOREIGN KEY (hangarno) REFERENCES public.hangar(hangarid);


--
-- TOC entry 4922 (class 2606 OID 17658)
-- Name: hangardakiucak hangardakiucak_ucakno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hangardakiucak
    ADD CONSTRAINT hangardakiucak_ucakno_fkey FOREIGN KEY (ucakno) REFERENCES public.ucak(ucakid);


--
-- TOC entry 4910 (class 2606 OID 17545)
-- Name: havalimani havalimani_sehirno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.havalimani
    ADD CONSTRAINT havalimani_sehirno_fkey FOREIGN KEY (sehirno) REFERENCES public.sehir(sehirid);


--
-- TOC entry 4907 (class 2606 OID 17509)
-- Name: havayolufirmasi havayolufirmasi_sehirno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.havayolufirmasi
    ADD CONSTRAINT havayolufirmasi_sehirno_fkey FOREIGN KEY (sehirno) REFERENCES public.sehir(sehirid);


--
-- TOC entry 4911 (class 2606 OID 17557)
-- Name: inisliman inisliman_limanno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inisliman
    ADD CONSTRAINT inisliman_limanno_fkey FOREIGN KEY (limanno) REFERENCES public.havalimani(limanid);


--
-- TOC entry 4930 (class 2606 OID 17744)
-- Name: kabinmemuru kabinmemuru_personelno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kabinmemuru
    ADD CONSTRAINT kabinmemuru_personelno_fkey FOREIGN KEY (personelno) REFERENCES public.personel(personelid);


--
-- TOC entry 4931 (class 2606 OID 17749)
-- Name: kabinmemuru kabinmemuru_ucakno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kabinmemuru
    ADD CONSTRAINT kabinmemuru_ucakno_fkey FOREIGN KEY (ucakno) REFERENCES public.ucak(ucakid);


--
-- TOC entry 4912 (class 2606 OID 17569)
-- Name: kalkisliman kalkisliman_limanno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kalkisliman
    ADD CONSTRAINT kalkisliman_limanno_fkey FOREIGN KEY (limanno) REFERENCES public.havalimani(limanid);


--
-- TOC entry 4925 (class 2606 OID 17692)
-- Name: personel personel_firmano_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personel
    ADD CONSTRAINT personel_firmano_fkey FOREIGN KEY (firmano) REFERENCES public.havayolufirmasi(havayoluid);


--
-- TOC entry 4928 (class 2606 OID 17725)
-- Name: pilot pilot_personelno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pilot
    ADD CONSTRAINT pilot_personelno_fkey FOREIGN KEY (personelno) REFERENCES public.personel(personelid);


--
-- TOC entry 4929 (class 2606 OID 17730)
-- Name: pilot pilot_ucakno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pilot
    ADD CONSTRAINT pilot_ucakno_fkey FOREIGN KEY (ucakno) REFERENCES public.ucak(ucakid);


--
-- TOC entry 4918 (class 2606 OID 17625)
-- Name: rezervasyon rezervasyon_ucusno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon
    ADD CONSTRAINT rezervasyon_ucusno_fkey FOREIGN KEY (ucusno) REFERENCES public.ucus(ucusid);


--
-- TOC entry 4919 (class 2606 OID 17620)
-- Name: rezervasyon rezervasyon_yolcuno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rezervasyon
    ADD CONSTRAINT rezervasyon_yolcuno_fkey FOREIGN KEY (yolcuno) REFERENCES public.yolcu(yolcuid);


--
-- TOC entry 4906 (class 2606 OID 17497)
-- Name: sehir sehir_ulkeno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sehir
    ADD CONSTRAINT sehir_ulkeno_fkey FOREIGN KEY (ulkeno) REFERENCES public.ulke(ulkeid);


--
-- TOC entry 4913 (class 2606 OID 17581)
-- Name: ucak ucak_firmano_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ucak
    ADD CONSTRAINT ucak_firmano_fkey FOREIGN KEY (firmano) REFERENCES public.havayolufirmasi(havayoluid);


--
-- TOC entry 4914 (class 2606 OID 17593)
-- Name: ucus ucus_firmano_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ucus
    ADD CONSTRAINT ucus_firmano_fkey FOREIGN KEY (firmano) REFERENCES public.havayolufirmasi(havayoluid);


--
-- TOC entry 4915 (class 2606 OID 17603)
-- Name: ucus ucus_inislimanno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ucus
    ADD CONSTRAINT ucus_inislimanno_fkey FOREIGN KEY (inislimanno) REFERENCES public.inisliman(inisid);


--
-- TOC entry 4916 (class 2606 OID 17598)
-- Name: ucus ucus_kalkislimanno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ucus
    ADD CONSTRAINT ucus_kalkislimanno_fkey FOREIGN KEY (kalkislimanno) REFERENCES public.kalkisliman(kalkisid);


--
-- TOC entry 4917 (class 2606 OID 17608)
-- Name: ucus ucus_ucakno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ucus
    ADD CONSTRAINT ucus_ucakno_fkey FOREIGN KEY (ucakno) REFERENCES public.ucak(ucakid);


--
-- TOC entry 4923 (class 2606 OID 17680)
-- Name: yedekparca yedekparca_limanno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yedekparca
    ADD CONSTRAINT yedekparca_limanno_fkey FOREIGN KEY (limanno) REFERENCES public.havalimani(limanid);


--
-- TOC entry 4924 (class 2606 OID 17675)
-- Name: yedekparca yedekparca_ucakno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yedekparca
    ADD CONSTRAINT yedekparca_ucakno_fkey FOREIGN KEY (ucakno) REFERENCES public.ucak(ucakid);


--
-- TOC entry 4926 (class 2606 OID 17711)
-- Name: yerhizmetleri yerhizmetleri_limanno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yerhizmetleri
    ADD CONSTRAINT yerhizmetleri_limanno_fkey FOREIGN KEY (limanno) REFERENCES public.havalimani(limanid);


--
-- TOC entry 4927 (class 2606 OID 17706)
-- Name: yerhizmetleri yerhizmetleri_personelno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yerhizmetleri
    ADD CONSTRAINT yerhizmetleri_personelno_fkey FOREIGN KEY (personelno) REFERENCES public.personel(personelid);


--
-- TOC entry 4908 (class 2606 OID 17521)
-- Name: yolcu yolcu_sehirno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yolcu
    ADD CONSTRAINT yolcu_sehirno_fkey FOREIGN KEY (sehirno) REFERENCES public.sehir(sehirid);


--
-- TOC entry 4932 (class 2606 OID 17763)
-- Name: yonetim yonetim_personelno_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.yonetim
    ADD CONSTRAINT yonetim_personelno_fkey FOREIGN KEY (personelno) REFERENCES public.personel(personelid);


-- Completed on 2024-12-19 13:35:22

--
-- PostgreSQL database dump complete
--