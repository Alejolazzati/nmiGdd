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
    public partial class altaCliente : Form
    {

        string nombre;
        string apellido;
        Date fechaElegida;
        string numeroDoc;
        String mail;
        string domicilio;
        string piso;
        string depto;
        String tipoDocumento;
        String Nacionalidad;
        String userName;
        String contraseña;
        String preguntaSecreta;
        String respuestaSecreta;
        int Rol;
        string numero;
        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            
        public altaCliente()
           {
            InitializeComponent();
            comando.CommandText = "Select * from documentosDisponibles()";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                comboBox2.Items.Add(reader.GetSqlString(0));
            }
            this.Show();

            reader.Dispose();
           
            
            //CARGAR NACIONALIDADES

            comando.CommandText = "Select * from getNacionalidades()";
            
            while (reader.Read())
            {
                comboBox1.Items.Add(reader.GetSqlString(0));
            }
            this.Show();

            reader.Dispose();
           
            //Cargar roles

            comando.CommandText = "Select * from rolesDisponibles()";

            while (reader.Read())
            {
                comboBox3.Items.Add(reader.GetSqlString(0));
            }
            this.Show();

            reader.Dispose();
           


        }


        private void button6_Click(object sender, EventArgs e)
        {
            new Calendario(this).Show();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            nombre = textBox11.Text;
            apellido = textBox1.Text;
            numeroDoc = textBox10.Text;
            mail = textBox9.Text;
            domicilio = textBox3.Text;
            piso = textBox7.Text;
            depto = textBox4.Text;
            tipoDocumento = comboBox2.SelectedItem.ToString();
            Nacionalidad = comboBox1.SelectedItem.ToString();
            userName=textBox6.Text;
            contraseña = textBox7.Text;
            preguntaSecreta = textBox8.Text;
            respuestaSecreta = textBox9.Text;
            numero = textBox12.Text;
            if (comboBox3.SelectedItem.ToString()=="Cliente") {
                        Rol = 1; 
            }
            else Rol=2;

            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "execute dbo.execute ingresarCliente '"+userName+"', '"+contraseña+"', '"+preguntaSecreta+"', '"+ respuestaSecreta+"' , '"+ nombre +"' , '"+apellido+ "' , '"+ tipoDocumento+ "' , " +numeroDoc+ ", '"+ mail +"' , "+ Rol + ", '"+ Nacionalidad +"' , '"+ domicilio+ "' , '"+ numero+ "' , '"+ piso +"','"+ depto+"', '"+ fechaElegida ;
            try { comando.ExecuteNonQuery(); }
            catch { MessageBox.Show("Ingrese correctamente los valores"); }
               
        }

        public void recibirFecha(System.DateTime unaFecha)
        {
            fechaElegida = unaFecha;
            textBox13.Text = unaFecha.ToShortDateString();
        }

        

        

    }
}
