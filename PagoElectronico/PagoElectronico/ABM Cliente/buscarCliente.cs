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
    public partial class buscarCliente : Form
    {
        string nombre;
        string apellido;
        string numeroDoc;
        string mail;
        int tipoDoc;
        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            
        public buscarCliente()
        {
            InitializeComponent();
            comando.CommandText = "Select nombre, apellido, mail, documento, tipoDocumento into #tablaTemporal from clientes";
            comando.ExecuteNonQuery();
            
            
        }

        private void button8_Click(object sender, EventArgs e)
        { //nuevoCliente
            new PagoElectronico.ABM_Cliente.altaCliente().Show();
            this.Close();
        }



              
       private void buscarCliente_Load(object sender, EventArgs e)
        {
            maskedTextBox1.Mask = "##############################";
       }

       private void button2_Click(object sender, EventArgs e)
        //BUSCAR
       {
           if (textBox1.TextLength > 0)
           {
               nombre = textBox1.Text;
               comando.CommandText = "Delete from #tablaTemporal where nombre not like" + "'%" + nombre + "%'";
               comando.ExecuteNonQuery();
            
           }

           if (textBox2.TextLength > 0)
           {
               apellido = textBox2.Text;
               comando.CommandText = "Delete from #tablaTemporal where apellido not like" + "'%" + apellido + "%'";
               comando.ExecuteNonQuery();
           }

           if (maskedTextBox1.TextLength > 0)
           {
               numeroDoc = maskedTextBox1.Text;
               comando.CommandText = "Delete from #tablaTemporal where numeroDoc not like" + "'%" + numeroDoc + "%'";
               comando.ExecuteNonQuery();
           }

           if (textBox3.TextLength > 0)
           {
               mail = textBox3.Text;
               comando.CommandText = "Delete from #tablaTemporal where mail<>" + "'" + mail + "'";
               comando.ExecuteNonQuery();

           }




           comando.CommandText = "Select * from #tablaTemporal";
           System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter(comando);
           DataSet set = new DataSet();
           adapter.Fill(set);
           dataGridView1.DataSource = set.Tables[0].DefaultView;
           adapter.Dispose();
           set.Dispose();

       }

       private void button1_Click(object sender, EventArgs e)
           //limpiar
       {
           new buscarCliente().Show();
           comando.CommandText = "drop #tablaTemporal";
           try
           {
               comando.ExecuteNonQuery();
           }
           catch { }
           this.Close();
       }

       private void maskedTextBox1_MaskInputRejected(object sender, MaskInputRejectedEventArgs e)
       {

       }

       private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
       {/*
           if (comboBox1.SelectedItem.ToString
           tipoDoc = comboBox1.SelectedItem.ToString();*/
       }

       private void textBox3_TextChanged(object sender, EventArgs e)
       {

       }




       
    }
}
