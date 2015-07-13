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
            comando.CommandText = "Select Categoria.precioSuscripcion,Descripcion from NMI.Cuenta,NMI.Categoria where codigo_categoria=id_categoria and num_cuenta=" + textBox2.Text;
            System.Data.SqlClient.SqlDataReader reader= comando.ExecuteReader();
            reader.Read();
           precio=float.Parse(reader.GetSqlValue(0).ToString());
           String categoria = reader.GetSqlValue(1).ToString();
            textBox4.Text = categoria;
            textBox1.Text = "0";
            reader.Dispose();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "execute NMI.pagarSuscripciones " + Program.cuenta + "," + textBox3.Text + "," +Program.factura/*+",'"+Program.fecha+"'"*/;
            try
            {
                comando.ExecuteNonQuery();
                MessageBox.Show("suscripcion asentada");
            }
            catch (System.Data.SqlClient.SqlException er)
            {
                MessageBox.Show(er.Message);
              
               

            }
            this.Close();
            
        }

       
        private void button3_Click(object sender, EventArgs e)
        {   if(textBox3.Text.Length>0)
            textBox1.Text = (Int32.Parse(textBox3.Text) * precio).ToString(); 
        else MessageBox.Show("ingrese cantidad");
        }

        
    }}
