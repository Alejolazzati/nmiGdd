using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_Cuenta
{
    public partial class modificarCuentaAdm : Form
    {

        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
        String pais;
        String moneda;
        String categoria;
        String cuenta;

        public modificarCuentaAdm(string numCuenta)
        {
            InitializeComponent();

            comboBox1.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox2.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox3.DropDownStyle = ComboBoxStyle.DropDownList;


            comando.CommandText = "Select p.descripcion from NMI.Cuenta join NMI.pais p on (Codigo_pais=Id_pais) where Num_cuenta="+numCuenta;
            System.Data.SqlClient.SqlDataReader reader4 = comando.ExecuteReader();
            reader4.Read();

            comboBox3.Text = reader4.GetSqlString(0).ToString();
            reader4.Dispose();

            
            
            //cargar moneda


            comando.CommandText = "Select descripcion from NMI.MONEDA";
            System.Data.SqlClient.SqlDataReader reader2 = comando.ExecuteReader();
            while (reader2.Read())
            {
                comboBox1.Items.Add(reader2.GetSqlString(0));

            }
            this.Show();
            reader2.Dispose();


            // cargar categoria


            comando.CommandText = "Select descripcion from NMI.categoria";
            System.Data.SqlClient.SqlDataReader reader3 = comando.ExecuteReader();
            while (reader3.Read())
            {
                comboBox2.Items.Add(reader3.GetSqlString(0));

            }
            this.Show();
            reader3.Dispose();


        }

        private void label5_Click(object sender, EventArgs e)
        {

        }

        private void modificarCuentaAdm_Load(object sender, EventArgs e)
        {

        }

        private void comboBox3_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
