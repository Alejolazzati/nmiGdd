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
        
        String nombre;
        String apellido;
        DateTime fechaElegida;
        Int32 numeroDoc;
        String mail;
        String domicilio;
        Int32 piso;
        String depto;
        String tipoDocumento;
        String Nacionalidad;
        String userName;
        String contraseña;
        String preguntaSecreta;
        String respuestaSecreta;
        int Rol;
        Int32 numero;
        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            
        public altaCliente()
           {
            InitializeComponent();
            comando.CommandText = "Select * from NMI.documentosDisponibles()";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                comboBox2.Items.Add(reader.GetSqlString(0));
            }
            

            reader.Dispose();
            
           
            
            //CARGAR NACIONALIDADES

            comando.CommandText = "Select * from NMI.getNacionalidades()";
            System.Data.SqlClient.SqlDataReader reader2 = comando.ExecuteReader();
            while (reader2.Read())
            {
                comboBox1.Items.Add(reader2.GetSqlString(0));
            }
            this.Show();

            reader2.Dispose();
           
            //Cargar roles

           

           
           


        }


        private void button6_Click(object sender, EventArgs e)
        {
            new Calendario(this).Show();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            nombre = textBox5.Text;
            apellido = textBox1.Text;
            numeroDoc = Int32.Parse(textBox10.Text);
            mail = textBox9.Text;
            domicilio = textBox3.Text;
            piso = Int32.Parse(textBox2.Text);
            depto = textBox4.Text;
            tipoDocumento = comboBox2.SelectedItem.ToString();
            Nacionalidad = comboBox1.SelectedItem.ToString();
            userName=textBox6.Text;
            contraseña = textBox7.Text;
            preguntaSecreta = textBox8.Text;
            respuestaSecreta = textBox11.Text;
            numero = Int32.Parse(textBox12.Text);
          
           
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "exec NMI.ingresarUsuario '" + userName + "','" + contraseña + "','" + preguntaSecreta + "','" + respuestaSecreta + "'," + 1.ToString();
            try { comando.ExecuteNonQuery();
            
           /* comando.CommandText = "NMI.facturar";
            comando.CommandType = CommandType.StoredProcedure;
            comando.Parameters.Add("@username", SqlDbType.VarChar);
            comando.Parameters.Add("@nombre", SqlDbType.VarChar);
            comando.Parameters.Add("@apellido", SqlDbType.VarChar);
            comando.Parameters.Add("@nombre", SqlDbType.VarChar);
            @apellido varchar(50),
@tipodoc varchar(50),@numerodedoc int,
@mail varchar(50),/*
@pais varchar(50),*//*@calle varchar(50),
@numero int,@piso int,
@depto char(1),@fecha date
            comando.Parameters["@numCliente"].Value = Program.cliente;
            comando.Parameters["@fact"].Value = Program.cliente;
       */
            
            comando.CommandText = "exec NMI.ingresarCliente '"+userName+"','"+nombre+"','"+apellido+"','"+tipoDocumento+"',"+numeroDoc+",'"+mail+"','"+Nacionalidad+"','"+domicilio+"',"+numero+","+piso+",'"+depto+"','"+fechaElegida+"'";
 

             /*   + userName + "', '" + nombre + 
                "' , '" + apellido + "' , '" + 
                tipoDocumento + "' , " + numeroDoc + ", '" + mail +
                "', '" /*+ Nacionalidad + "' , '"*//* + domicilio + "' , " + numero +
                " , " + piso + ",'" + depto + "', '"+ fechaElegida+"'" ;
            */
           
                comando.ExecuteNonQuery(); new PagoElectronico.Login.Funcionalidades().Show();
                this.Close();
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                MessageBox.Show(ex.Message);
             
            }
            catch { MessageBox.Show("Ingrese correctamente los valores"); }

               
        }

        public void recibirFecha(System.DateTime unaFecha)
        {
            fechaElegida = unaFecha;
            textBox13.Text = unaFecha.ToShortDateString();
        }

        private void altaCliente_Load(object sender, EventArgs e)
        {

        }

        private void comboBox3_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void groupBox2_Enter(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            new PagoElectronico.Login.Funcionalidades().Show();
            this.Close();
        }

        

        

    }
}
