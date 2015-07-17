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
    public partial class ListadoFactura : Form
    {
        public ListadoFactura()
        {
           
          
            InitializeComponent();
        }

        private void ListadoFactura_Load(object sender, EventArgs e)
        {
            label2.Text = Program.factura.ToString();
            System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
            comando.CommandText = "select item,precio from NMI.listadoFactura(" + Program.factura.ToString() + ")";
            System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter(comando);
            DataSet set = new DataSet();
            adapter.Fill(set);
            dataGridView2.DataSource = set.Tables[0].DefaultView;
            adapter.Dispose();
            set.Dispose();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        

       
    }
}
