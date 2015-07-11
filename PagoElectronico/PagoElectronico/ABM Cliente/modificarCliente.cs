using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_Cliente
{
    public partial class modificarCliente : Form
    {
        String cliente;

        string nombre;
        string apellido;
        DateTime fechaElegida;
        String numeroDoc;
        String mail;
        string domicilio;
        int piso;
        string depto;
        string tipoDocumento;
        String Nacionalidad;
        String userName;
        String contraseña;
        String preguntaSecreta;
        String respuestaSecreta;
        int Rol;
        String numero;
        
        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            

        public modificarCliente(String clie)
        {
            cliente = clie;
            InitializeComponent();
            
            
            comando.CommandText = "Select * from dbo.datosDelCliente(" + cliente  + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            reader.Read();
            nombre = reader.GetString(2);
            apellido = reader.GetString(3);
            tipoDocumento = reader.GetString(4);
            numeroDoc = reader.GetSqlValue(5).ToString();
            mail = reader.GetString(6);
            domicilio = reader.GetString(8);
            numero = reader.GetSqlValue(9).ToString();
            piso = reader.GetInt32(10);
            depto = reader.GetString(11);
            textBox11.Text = nombre;
            textBox1.Text = apellido;
            textBox10.Text = numeroDoc.ToString();
            textBox9.Text = mail;
            textBox3.Text = domicilio;
            textBox7.Text = numero;
            textBox4.Text = depto;
            textBox2.Text = piso.ToString();           

            reader.Dispose();
        
        }

        private void button4_Click(object sender, EventArgs e)
        {

            nombre = textBox11.Text;
            apellido = textBox1.Text;
            numeroDoc = textBox10.Text;
            mail = textBox9.Text;
            domicilio = textBox3.Text;
            numero = textBox7.Text;
            depto = textBox4.Text;
            piso = Convert.ToInt32(textBox2.Text);    
            comando.CommandText = "execute dbo.updeteaDatosDelCliente " + cliente + ", '" + nombre + "','" + apellido + "','" + tipoDocumento + "'," + numeroDoc + ",'"+mail+"','"+domicilio+"'," + numero + "," + piso + ",'" + depto + "','" + fechaElegida + "'";
            try
            {
                comando.ExecuteNonQuery();
                MessageBox.Show("Actualizacion correcta");
            }
            catch (System.Data.SqlClient.SqlException er)
            {
                MessageBox.Show(er.Message);
            }

        }

       
    }
}
