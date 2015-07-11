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
        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            
        public buscarCliente()
        {
            InitializeComponent();
            comando.CommandText = "Select ID_cliente, Nombre, Apellido, mail, numero_documento, tipoDeDocumento=(Select Descripcion from tipo_Dni where id_DNI=tipo_documento) into #tablaTemporal from Cliente";
            comando.ExecuteNonQuery();

            comboBox1.Items.Add("no especifica");
            comando.CommandText = "Select * from documentosDisponibles()";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                comboBox1.Items.Add(reader.GetSqlString(0));
            }
            this.Show();

            reader.Dispose();
            

            
            
        }

        private void button8_Click(object sender, EventArgs e)
        { //nuevoCliente
            new PagoElectronico.ABM_Cliente.altaCliente().Show();
            this.Close();
        }



              
       private void buscarCliente_Load(object sender, EventArgs e)
        {
            maskedTextBox1.Mask = "0999999999999999999999999999";
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

           if (maskedTextBox1.MaskCompleted)
           {
               numeroDoc = maskedTextBox1.Text;
               comando.CommandText = "Delete from #tablaTemporal where numero_Documento <> '"+numeroDoc+"'";
               comando.ExecuteNonQuery();
           }

           if (textBox3.TextLength > 0)
           {
               mail = textBox3.Text;
               comando.CommandText = "Delete from #tablaTemporal where mail<>" + "'" + mail + "'";
               comando.ExecuteNonQuery();

           }

           if (comboBox1.SelectedIndex>0)
           {
               comando.CommandText = "Delete from #tablaTemporal where tipoDeDocumento<>" + "'" + comboBox1.SelectedItem.ToString() + "'";
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
           
           comando.CommandText = "drop table #tablaTemporal";
           try
           {
               comando.ExecuteNonQuery();
           }
           catch { }
           new buscarCliente().Show();
           this.Close();
       }

       private void button3_Click(object sender, EventArgs e)
       { //booton modificar 
          // System.Data.DataSet.Enumerator enum = 
         // System.Collections.IEnumerator enum =dataGridView1.SelectedRows.GetEnumerator();
           if (dataGridView1.SelectedRows.Count == 1)
           {
               DataGridViewRow row = this.dataGridView1.SelectedRows[0];
              new modificarCliente(row.Cells["id_cliente"].Value.ToString()).Show();
           }
           else MessageBox.Show("seleccione una fila");
           


       }

         
    }
}
