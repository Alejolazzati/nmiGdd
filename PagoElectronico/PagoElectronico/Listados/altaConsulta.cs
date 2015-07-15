using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.Listados
{
    public partial class altaConsulta : Form
    {
        int trimestre; // 1 = primer 2= 2do 3= 3ro
        string año;
        public altaConsulta()
        {
            InitializeComponent();
            comboBox1.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox2.DropDownStyle = ComboBoxStyle.DropDownList;

            comboBox1.Items.Add("Primer trimestre");
            comboBox1.Items.Add("Segundo trimestre");
            comboBox1.Items.Add("Tercer trimestre");
            comboBox1.Items.Add("Cuarto trimestre");

            comboBox2.Items.Add("Clientes con cuentas inhabilitadas por morosos");
            comboBox2.Items.Add("Clientes con mayor cantidad de comisiones facturadas en sus cuentas");
            comboBox2.Items.Add("Clientes con mayor cantidad de transacciones realizadas entre cuentras propias");
            comboBox2.Items.Add("Paises con mayor cantidad de movimientos");
            comboBox2.Items.Add("Total facturado para los distintos tipos de cuenta");

        }

        private void altaConsulta_Load(object sender, EventArgs e)
        {

        }

        private void button3_Click(object sender, EventArgs e)
        {
          
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button4_Click(object sender, EventArgs e)
        {
           
        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button5_Click(object sender, EventArgs e)
        {
            if (textBox1.Text.Length == 0)
            { 
                MessageBox.Show("Ingrese un año valido");
            }
            año = textBox1.Text;

            if (comboBox1.SelectedIndex==-1)
            {
                MessageBox.Show("Seleccione un trimestre");
            }
            trimestre = comboBox1.SelectedIndex + 1;

            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
           
            int opcion=comboBox2.SelectedIndex;

            if (comboBox2.SelectedIndex == -1)
            {
                MessageBox.Show("Seleccione una opción a visualizar");
            }

            switch (opcion){
                case 0:
                    comando.CommandText = "Select * from NMI.clientesInhabilitados(" + año+"," + trimestre + ")";
                    break;

                case 1:
                    comando.CommandText = "exec NMI.clietesMasFacturas " + año + "," + trimestre + "";
                    break;

                case 2:
                    comando.CommandText = "exec NMI.clientesConMasTransferenciasEntreCuentasPropias " + año + "," + trimestre + "";
                    break;

                case 3:
                    comando.CommandText = "exec NMI.PaisesMasMov " + año + "," + trimestre + "";
                    break;

                case 4:
                    comando.CommandText = "exec NMI.SaldoPorFacturas " + año + "," + trimestre + "";
                    break;

            }
            System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter(comando);
            DataSet set = new DataSet();
            adapter.Fill(set);
            dataGridView1.DataSource = set.Tables[0].DefaultView;
            adapter.Dispose();
            set.Dispose();
        }

        private void button2_Click(object sender, EventArgs e)
        {
            new PagoElectronico.Listados.altaConsulta().Show();
            this.Close();
            this.Hide();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            new PagoElectronico.Login.Funcionalidades().Show();
            this.Close();
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
