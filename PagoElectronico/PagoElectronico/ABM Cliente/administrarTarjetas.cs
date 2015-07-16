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
    public partial class administrarTarjetas : Form
    {
        public administrarTarjetas()
        {
            InitializeComponent();
            //cargar tarjetas del cliente
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "select * from NMI.tarjetasCliente("+ Program.cliente+ ")";
            System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter(comando);
            DataSet set = new DataSet();
            adapter.Fill(set);
            dataGridView1.DataSource = set.Tables[0].DefaultView;
            adapter.Dispose();
            set.Dispose();

        }

        private void listBox2_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (dataGridView1.SelectedRows.Count == 1)
            {
                Int32 numTarjeta;
                DataGridViewRow row = this.dataGridView1.SelectedRows[0];
                numTarjeta=Int32.Parse(row.Cells["idTarjeta"].Value.ToString());

                System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
                comando.CommandText = "exce nmi.desaasociarTarjeta " + numTarjeta;
            }
            else MessageBox.Show("seleccione una fila");
            



        }
    }
}
