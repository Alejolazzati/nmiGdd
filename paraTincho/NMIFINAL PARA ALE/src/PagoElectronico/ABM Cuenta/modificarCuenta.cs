﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace PagoElectronico.ABM_Cuenta
{
    public partial class modificarCuenta : Form
    {

        System.Data.SqlClient.SqlCommand comando = Coneccion.getComando();
        String pais;
        String moneda;
        String categoria;
        String cuenta;

        public modificarCuenta(string numCuenta)
        {
            InitializeComponent();
            cuenta=numCuenta;
            comboBox1.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox2.DropDownStyle = ComboBoxStyle.DropDownList;
            comboBox3.DropDownStyle = ComboBoxStyle.DropDownList;


            comando.CommandText = "Select p.descripcion, m.descripcion, c.descripcion from NMI.Cuenta join NMI.categoria c on (c.Id_categoria=Codigo_categoria) join NMI.moneda m on (m.Id_moneda=codigo_moneda) join NMI.pais p on (Codigo_pais=Id_pais) where Num_cuenta="+numCuenta;
            System.Data.SqlClient.SqlDataReader reader4 = comando.ExecuteReader();
            reader4.Read();

            comboBox3.Text = reader4.GetString(0);
            comboBox1.Text = reader4.GetString(1);
            comboBox2.Text = reader4.GetString(2);
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

            // cargar pais


            comando.CommandText = "Select descripcion from NMI.pais";
            System.Data.SqlClient.SqlDataReader reader7 = comando.ExecuteReader();
            while (reader7.Read())
            {
                comboBox3.Items.Add(reader7.GetSqlString(0));

            }
            this.Show();
            reader7.Dispose();



        }

        private void button2_Click(object sender, EventArgs e)
        { //al confirmar

            //lecturas de los comboBox
            try
            {
                pais = comboBox3.SelectedItem.ToString();
                categoria = comboBox2.SelectedItem.ToString();
                moneda = comboBox1.SelectedItem.ToString();
            }
            catch (NullReferenceException er) { MessageBox.Show("Complete los campos"); return; }
            comando.CommandText = "exec NMI.modificarCuenta "+cuenta+", '"+pais+"', '"+moneda+"','"+categoria+"'";
            try
            {
                comando.ExecuteNonQuery();
                MessageBox.Show("Operacion exitosa");
                this.Close();
            }
            catch (System.Data.SqlClient.SqlException er)
            {
                MessageBox.Show(er.Message);
            }
           
        }
    }
}
