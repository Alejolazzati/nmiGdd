using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.Facturacion
{
    public partial class pagarSuscripciones : Form
    {
        float precio;
        public pagarSuscripciones()
        {
            InitializeComponent();
        }

        private void pagarSuscripciones_Load(object sender, EventArgs e)
        {
            textBox2.Text = Program.cuenta.ToString();
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select Categoria.precioSuscripcion,Descripcion from Cuenta,Categoria where codigo_categoria=id_categoria and num_cuenta=" + textBox2.Text;
            System.Data.SqlClient.SqlDataReader reader= comando.ExecuteReader();
            reader.Read();
           precio=float.Parse(reader.GetSqlValue(0).ToString());
           String categoria = reader.GetSqlValue(1).ToString();
            textBox4.Text = categoria;
        }

        
    }}
