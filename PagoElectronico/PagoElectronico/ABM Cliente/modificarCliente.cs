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
        

        public modificarCliente(String clie)
        {
            cliente = clie;
            InitializeComponent();
            
            
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
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

       

       
    }
}
