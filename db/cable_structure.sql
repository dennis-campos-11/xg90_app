\restrict vgvzSIDv2P7YUNe8agMJqPg4D1utItt2dZr1oeN6FnvfwMTQK7xQMP5ILcd5xdI

-- Dumped from database version 15.14 (Postgres.app)
-- Dumped by pg_dump version 15.14 (Postgres.app)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- PostgreSQL database dump complete
--

\unrestrict vgvzSIDv2P7YUNe8agMJqPg4D1utItt2dZr1oeN6FnvfwMTQK7xQMP5ILcd5xdI

SET search_path TO "$user", public;

