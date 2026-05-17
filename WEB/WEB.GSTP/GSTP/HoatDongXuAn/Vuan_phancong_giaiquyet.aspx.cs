using BL.GSTP.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP.HoatDongXuAn
{
    public partial class Vuan_phancong_giaiquyet : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    hddPageIndex.Value = "1";
                    LoadData();
                }
            }
            catch (Exception ex) { lblthongbao.Text = ex.Message; }
        }
        private bool CheckValid()
        {
            if (txtTuNgay.Text.Trim() != "" && Cls_Comon.IsValidDate(txtTuNgay.Text) == false)
            {
                lblthongbao.Text = "Ngày tháng phải nhập theo định dạng (dd/MM/yyyy)!";
                txtTuNgay.Focus();
                return false;
            }
            if (txtDenNgay.Text.Trim() != "" && Cls_Comon.IsValidDate(txtDenNgay.Text) == false)
            {
                lblthongbao.Text = "Ngày tháng phải nhập theo định dạng (dd/MM/yyyy)!";
                txtDenNgay.Focus();
                return false;
            }
            if (txtTuNgay.Text.Trim() != "" && txtDenNgay.Text.Trim() != "")
            {
                DateTime TuNgay = DateTime.Parse(txtTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault),
                       DenNgay = DateTime.Parse(txtDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                if (DateTime.Compare(TuNgay, DenNgay) > 0)
                {
                    lblthongbao.Text = "Từ ngày phải nhỏ hơn đến ngày.";
                    txtTuNgay.Focus();
                    return false;
                }
            }
            return true;
        }
        private void LoadData()
        {
            lblthongbao.Text = "";
            PhanTrangTren.Visible = PhanTrangDuoi.Visible = true;
            if (!CheckValid())
            {
                return;
            }
            decimal ThamPhanID = string.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_GSTP] + "") ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_GSTP]);
            DateTime? TuNgay = txtTuNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault),
                     DenNgay = txtDenNgay.Text == "" ? (DateTime?)null : DateTime.Parse(txtDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
            string listTrangThai = "", vaitro = ddlVaiTro.SelectedValue, TenVuAn = txtTenVuAn.Text.Trim();
            int Total = 0, pageSize = Convert.ToInt32(hddPageSize.Value), vGetAll = 1;
            foreach (ListItem item in chkListTrangThai.Items)
            {
                if (item.Selected)
                {
                    switch (item.Value)
                    {
                        case "huy":
                            if (listTrangThai != "")
                            {
                                listTrangThai += ";huy";
                            }
                            else
                            {
                                listTrangThai = "huy";
                            }
                            break;
                        case "sua":
                            if (listTrangThai != "")
                            {
                                listTrangThai += ";sua";
                            }
                            else
                            {
                                listTrangThai = "sua";
                            }
                            break;
                        case "treo":
                            if (listTrangThai != "")
                            {
                                listTrangThai += ";treo";
                            }
                            else
                            {
                                listTrangThai = "treo";
                            }
                            break;
                        case "tamthoi":
                            if (listTrangThai != "")
                            {
                                listTrangThai += ";tamthoi";
                            }
                            else
                            {
                                listTrangThai = "tamthoi";
                            }
                            break;
                        case "tamdc":
                            if (listTrangThai != "")
                            {
                                listTrangThai += ";tamdc";
                            }
                            else
                            {
                                listTrangThai = "tamdc";
                            }
                            break;
                        case "dinhchi":
                            if (listTrangThai != "")
                            {
                                listTrangThai += ";dinhchi";
                            }
                            else
                            {
                                listTrangThai = "dinhchi";
                            }
                            break;
                        case "quahan":
                            if (listTrangThai != "")
                            {
                                listTrangThai += ";quahan";
                            }
                            else
                            {
                                listTrangThai = "quahan";
                            }
                            break;
                    }
                }
            }
            GSTP_BL bl = new GSTP_BL();
            if (ddlVaiTro.SelectedValue == "")// tất cả
            {
                vaitro = "VTTP_GIAIQUYETDON,VTTP_GIAIQUYETSOTHAM,VTTP_GIAIQUYETPHUCTHAM,THAMPHAN,";
                vGetAll = 1;
            }
            else
            {
                vaitro = ddlVaiTro.SelectedValue + ",";
                vGetAll = 0;
            }
            DataTable tbl = bl.DS_VUAN_OF_ThamPhan_BY_VAITRO_PLUS(ThamPhanID, vaitro, TenVuAn, TuNgay, DenNgay, vGetAll);
            DataTable temp = tbl.Clone(), tblSelect = tbl.Clone();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                if (listTrangThai != "")
                {
                    string[] arr = listTrangThai.Split(';');
                    foreach (string str in arr)
                    {
                        if (str == "huy")
                        {
                            try
                            {
                                tblSelect = tbl.Select("TrangThai like '%hủy%'").CopyToDataTable();
                                if (tblSelect.Rows.Count > 0)
                                {
                                    foreach (DataRow item in tblSelect.Rows)
                                    {
                                        DataRow row = temp.NewRow();
                                        row["VuAnID"] = item["VuAnID"]; row["MaVuAn"] = item["MaVuAn"]; row["TenVuAn"] = item["TenVuAn"];
                                        row["TenToaAn"] = item["TenToaAn"]; row["LinhVuc"] = item["LinhVuc"]; row["ARRTHUTU"] = item["ARRTHUTU"];
                                        row["TenMaGiaiDoan"] = item["TenMaGiaiDoan"]; row["NGAYPHANCONG"] = item["NGAYPHANCONG"];
                                        row["TrangThaiEX"] = item["TrangThaiEX"];
                                        temp.Rows.Add(row);
                                    }
                                }
                            }
                            catch { }
                        }
                        else if (str == "sua")
                        {
                            try
                            {
                                tblSelect = tbl.Select("TrangThai like '%sửa%'").CopyToDataTable();
                                if (tblSelect.Rows.Count > 0)
                                {
                                    foreach (DataRow item in tblSelect.Rows)
                                    {
                                        DataRow row = temp.NewRow();
                                        row["VuAnID"] = item["VuAnID"]; row["MaVuAn"] = item["MaVuAn"]; row["TenVuAn"] = item["TenVuAn"];
                                        row["TenToaAn"] = item["TenToaAn"]; row["LinhVuc"] = item["LinhVuc"]; row["ARRTHUTU"] = item["ARRTHUTU"];
                                        row["TenMaGiaiDoan"] = item["TenMaGiaiDoan"]; row["NGAYPHANCONG"] = item["NGAYPHANCONG"];
                                        row["TrangThaiEX"] = item["TrangThaiEX"];
                                        temp.Rows.Add(row);
                                    }
                                }
                            }
                            catch { }
                        }
                        else if (str == "treo")
                        {
                            try
                            {
                                tblSelect = tbl.Select("TrangThai like '%treo%'").CopyToDataTable();
                                if (tblSelect.Rows.Count > 0)
                                {
                                    foreach (DataRow item in tblSelect.Rows)
                                    {
                                        DataRow row = temp.NewRow();
                                        row["VuAnID"] = item["VuAnID"]; row["MaVuAn"] = item["MaVuAn"]; row["TenVuAn"] = item["TenVuAn"];
                                        row["TenToaAn"] = item["TenToaAn"]; row["LinhVuc"] = item["LinhVuc"]; row["ARRTHUTU"] = item["ARRTHUTU"];
                                        row["TenMaGiaiDoan"] = item["TenMaGiaiDoan"]; row["NGAYPHANCONG"] = item["NGAYPHANCONG"];
                                        row["TrangThaiEX"] = item["TrangThaiEX"];
                                        temp.Rows.Add(row);
                                    }
                                }
                            }
                            catch { }
                        }
                        else if (str == "tamthoi")
                        {
                            try
                            {
                                tblSelect = tbl.Select("TrangThai like '%biện pháp khẩn cấp tạm thời%'").CopyToDataTable();
                                if (tblSelect.Rows.Count > 0)
                                {
                                    foreach (DataRow item in tblSelect.Rows)
                                    {
                                        DataRow row = temp.NewRow();
                                        row["VuAnID"] = item["VuAnID"]; row["MaVuAn"] = item["MaVuAn"]; row["TenVuAn"] = item["TenVuAn"];
                                        row["TenToaAn"] = item["TenToaAn"]; row["LinhVuc"] = item["LinhVuc"]; row["ARRTHUTU"] = item["ARRTHUTU"];
                                        row["TenMaGiaiDoan"] = item["TenMaGiaiDoan"]; row["NGAYPHANCONG"] = item["NGAYPHANCONG"];
                                        row["TrangThaiEX"] = item["TrangThaiEX"];
                                        temp.Rows.Add(row);
                                    }
                                }
                            }
                            catch { }
                        }
                        else if (str == "tamdc")
                        {
                            try
                            {
                                tblSelect = tbl.Select("TrangThai like '%tạm đình chỉ%'").CopyToDataTable();
                                if (tblSelect.Rows.Count > 0)
                                {
                                    foreach (DataRow item in tblSelect.Rows)
                                    {
                                        DataRow row = temp.NewRow();
                                        row["VuAnID"] = item["VuAnID"]; row["MaVuAn"] = item["MaVuAn"]; row["TenVuAn"] = item["TenVuAn"];
                                        row["TenToaAn"] = item["TenToaAn"]; row["LinhVuc"] = item["LinhVuc"]; row["ARRTHUTU"] = item["ARRTHUTU"];
                                        row["TenMaGiaiDoan"] = item["TenMaGiaiDoan"]; row["NGAYPHANCONG"] = item["NGAYPHANCONG"];
                                        row["TrangThaiEX"] = item["TrangThaiEX"];
                                        temp.Rows.Add(row);
                                    }
                                }
                            }
                            catch { }
                        }
                        else if (str == "dinhchi")
                        {
                            try
                            {
                                tblSelect = tbl.Select("TrangThai like '%bị đình chỉ%'").CopyToDataTable();
                                if (tblSelect.Rows.Count > 0)
                                {
                                    foreach (DataRow item in tblSelect.Rows)
                                    {
                                        DataRow row = temp.NewRow();
                                        row["VuAnID"] = item["VuAnID"]; row["MaVuAn"] = item["MaVuAn"]; row["TenVuAn"] = item["TenVuAn"];
                                        row["TenToaAn"] = item["TenToaAn"]; row["LinhVuc"] = item["LinhVuc"]; row["ARRTHUTU"] = item["ARRTHUTU"];
                                        row["TenMaGiaiDoan"] = item["TenMaGiaiDoan"]; row["NGAYPHANCONG"] = item["NGAYPHANCONG"];
                                        row["TrangThaiEX"] = item["TrangThaiEX"];
                                        temp.Rows.Add(row);
                                    }
                                }
                            }
                            catch { }
                        }
                        else if (str == "quahan")
                        {
                            try
                            {
                                tblSelect = tbl.Select("TrangThai like '%quá hạn%'").CopyToDataTable();
                                if (tblSelect.Rows.Count > 0)
                                {
                                    foreach (DataRow item in tblSelect.Rows)
                                    {
                                        DataRow row = temp.NewRow();
                                        row["VuAnID"] = item["VuAnID"]; row["MaVuAn"] = item["MaVuAn"]; row["TenVuAn"] = item["TenVuAn"];
                                        row["TenToaAn"] = item["TenToaAn"]; row["LinhVuc"] = item["LinhVuc"]; row["ARRTHUTU"] = item["ARRTHUTU"];
                                        row["TenMaGiaiDoan"] = item["TenMaGiaiDoan"]; row["NGAYPHANCONG"] = item["NGAYPHANCONG"];
                                        row["TrangThaiEX"] = item["TrangThaiEX"];
                                        temp.Rows.Add(row);
                                    }
                                }
                            }
                            catch { }
                        }
                    }
                    if (temp.Rows.Count > 0)
                    {
                        tblSelect.Clear();
                        tblSelect = temp.DefaultView.ToTable(true, "VuAnID,MaVuAn,TenVuAn,TenToaAn,LinhVuc,MAGIAIDOAN,TenMaGiaiDoan,NGAYPHANCONG,ARRTHUTU,TrangThai").Select("1=1", "ARRTHUTU ASC,LinhVuc ASC,MAGIAIDOAN ASC,NGAYPHANCONG DESC").CopyToDataTable();
                    }
                }
                else
                {
                    tblSelect = tbl.Select("1=1", "ARRTHUTU ASC,LinhVuc ASC,MAGIAIDOAN ASC,NGAYPHANCONG DESC").CopyToDataTable();
                }
                Total = tblSelect.Rows.Count;
                if (Total > 0)
                {
                    hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, pageSize).ToString();
                    lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                                 lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                }
                else { lblthongbao.Text = "Không tìm thấy dữ liệu."; PhanTrangTren.Visible = PhanTrangDuoi.Visible = false; }
            }
            else { lblthongbao.Text = "Không tìm thấy dữ liệu."; PhanTrangTren.Visible = PhanTrangDuoi.Visible = false; }
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 1;
            dgList.PageSize = pageSize;
            dgList.DataSource = tblSelect;
            dgList.DataBind();
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lblthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lblthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { lblthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { lblthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { lblthongbao.Text = ex.Message; }
        }
        #endregion
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { lblthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                Label lblTrangThai = (Label)e.Item.FindControl("lblTrangThai");
                Label lblNgayPhanCong = (Label)e.Item.FindControl("lblNgayPhanCong");
                lblNgayPhanCong.Text = rowView["NGAYPHANCONG"] + "" == "" ? "" : DateTime.Parse(rowView["NGAYPHANCONG"] + "", cul, DateTimeStyles.NoCurrentDateDefault).ToString("dd/MM/yyyy");
                string TrangThai = rowView["TrangThai"] + "";
                if (TrangThai != "" && TrangThai.Contains(','))
                {
                    TrangThai = TrangThai.Trim();
                    lblTrangThai.Text = TrangThai.Substring(0, TrangThai.Length - 6);
                }
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            string[] arr = e.CommandArgument.ToString().Split('#');
            string VuAnID = arr[0], LinhVuc = arr[1], GiaiDoan = arr[2];
            Session["GSTP_CALL_VUAN_INFO"] = VuAnID;
            if (e.CommandName == "ChiTiet")
            {
                switch (LinhVuc)
                {
                    case "Hình sự":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupAHS_DGQ()");
                        break;
                    case "Dân sự":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupADS_DGQ()");
                        break;
                    case "HN & GĐ":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupAHN_DGQ()");
                        break;
                    case "KD,TM":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupAKT_DGQ()");
                        break;
                    case "Lao động":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupALD_DGQ()");
                        break;
                    case "Hành chính":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupAHC_DGQ()");
                        break;
                    case "Phá sản":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupAPS_DGQ()");
                        break;
                    case "BP XLHC":
                        Cls_Comon.CallFunctionJS(this, this.GetType(), "CallPopupBPXLHC_DGQ()");
                        break;
                }
            }
        }
    }
}