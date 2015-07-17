using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.Depositos
{
    public partial class altaDeposito : Form
    {
        String cuenta;
        String moneda;
        float importe;

        public altaDeposito()
        {
            InitializeComponent();
            this.refresh();
            comboBox1.DropDownStyle = ComboBoxStyle.DropDownList;
          
        }
        private void refresh()
        {
            listBox1.Items.Clear();
            
            //cargar tarjetas del cliente
            
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "select * from NMI.tarjetasCliente(" + Program.cliente + ")";
            System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter(comando);
            DataSet set = new DataSet();
            adapter.Fill(set);
            dataGridView1.DataSource = set.Tables[0].DefaultView;
            adapter.Dispose();
            set.Dispose();
            comando.CommandText = "Select * from NMI.cuentasPorCliente(" + Program.cliente + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();

            while (reader.Read())
            {
                listBox1.Items.Add(reader.GetSqlValue(0));
                this.Show();


            }
            reader.Dispose();

            comando.CommandText = "select NMI.Moneda.Descripcion from NMI.Moneda";
            reader = comando.ExecuteReader();
            while (reader.Read())
            {
                comboBox1.Items.Add(reader.GetSqlString(0));

            }
            this.Show();
            reader.Dispose();



  

        }

       
        private void listBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            String cuenta = listBox1.SelectedItem.ToString();
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "Select NMI.saldoCuenta(" + cuenta + ")";
            System.Data.SqlClient.SqlDataReader reader = comando.ExecuteReader();
            reader.Read();
            textBox3.Text = reader.GetSqlValue(0).ToString();
            reader.Dispose();
        }

        private void maskedTextBox1_Validating(object sender, CancelEventArgs e)
        {
            e.Cancel = int.Parse(maskedTextBox1.Text) > 0;
        }

        private void button4_Click(object sender, EventArgs e)
        {
            PagoElectronico.Login.Funcionalidades formFuncion = new PagoElectronico.Login.Funcionalidades();
            formFuncion.Show();
            this.Close();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            //confirmar
            int i = 0;
            try
            {
                cuenta = listBox1.SelectedItem.ToString();
            }
            catch (NullReferenceException er) { MessageBox.Show("Elija una cuenta"); i++; }

            try
            {
                moneda = comboBox1.SelectedItem.ToString();
            }
            catch (NullReferenceException er) { MessageBox.Show("Elija la moneda"); i++; }

            if (maskedTextBox1.Text.Length == 0)
            {
                MessageBox.Show("Ingrese un importe");
                i++;
            }
            if (i > 0) return;

            try
            {
                importe=float.Parse(maskedTextBox1.Text);
                if(maskedTextBox1.Text.Contains(",")){MessageBox.Show("debe usar el caracter . como separador de decimales");return;}
            }
            catch (FormatException ex) { MessageBox.Show("debe ingresar el importe en formato punto flotante"); return; }

            

            if (dataGridView1.SelectedRows.Count == 1)
            {
                Int32 numTarjeta;
                DataGridViewRow row = this.dataGridView1.SelectedRows[0];
                numTarjeta = Int32.Parse(row.Cells["idTarjeta"].Value.ToString());

                System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
               
                comando.CommandText = "exec NMI.asentarDeposito "+cuenta+", "+numTarjeta+","+importe+",'"+moneda+"'";
                try
                {
                    comando.ExecuteNonQuery();
                    MessageBox.Show("Operacion exitosa");
                    this.refresh();
                }
                catch (System.Data.SqlClient.SqlException er) { MessageBox.Show(er.Message); }
            }
            else MessageBox.Show("seleccione una fila");
            
        }
    }
}
