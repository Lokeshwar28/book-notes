--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 17.0 (Postgres.app)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: books; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.books (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    isbn character varying(30),
    read_date date NOT NULL,
    rating integer,
    notes text,
    CONSTRAINT books_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.books OWNER TO postgres;

--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.books_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.books_id_seq OWNER TO postgres;

--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- Name: books id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.books (id, title, author, isbn, read_date, rating, notes) VALUES
(2, 'The Pragmatic Programmer', 'Andrew Hunt & David Thomas', '9780201616224', '2024-02-01', 4, 'Very insightful for software development best practices.'),
(5, 'Zero to One', 'Peter Thiel', '9780804139298', '2023-11-05', 5, 'Must-read for startup enthusiasts.'),
(6, 'Sapiens: A Brief History of Humankind', 'Yuval Noah Harari', '9780099590088', '2023-10-20', 5, 'Fascinating history of humankind.'),
(7, 'Clean Code', 'Robert C. Martin', '9780132350884', '2024-02-02', 5, 'Every developer should read this.'),
(8, 'The Lean Startup', 'Eric Ries', '9780307887894', '2024-02-10', 4, 'Great for understanding startup methodologies.'),
(3, 'Deep Work', 'Cal Newport', '9781455586691', '2024-01-25', 5, 'Focus is key to success! Success is key..'),
(9, 'Atomic Habits', 'James Clear', '9780735211292', '2024-01-15', 5, 'A great book on building good habits and breaking bad ones. Practical and easy-to-follow advice.'),
(10, 'The Alchemist', 'Paulo Coelho', '9780062315007', '2023-12-10', 4, 'An inspiring novel about following one’s dreams and listening to one’s heart. Beautiful storytelling.');


--
-- Name: books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.books_id_seq', 10, true);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

