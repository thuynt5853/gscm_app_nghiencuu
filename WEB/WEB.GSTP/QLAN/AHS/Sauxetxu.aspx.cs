using BL.GSTP.AHS;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS
{
    public partial class Sauxetxu : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private static DataTable dsSelected;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    dsSelected = CreateTableSelected();
                    ptT.Visible = ptB.Visible = false;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void LoadGrid()
        {
            lbthongbao.Text = "";
            ptT.Visible = ptB.Visible = true;
            if (rdbTrangthai.SelectedValue == "0")
                hddShowCommand.Value = "False";
            else
                hddShowCommand.Value = "True";

            decimal vDonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DateTime? dFrom = DateTime.Now;
            DateTime? dTo = DateTime.Now;
            dFrom = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            dTo = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            AHS_PHUCTHAM_BL oBL = new AHS_PHUCTHAM_BL();
            int pageSize = dgList.PageSize, pageIndex = Convert.ToInt32(hddPageIndex.Value);
            DataTable oDT = oBL.AHS_RUTKN(vDonViID, txtMaVuAn.Text, txtTenVuAn.Text, txtSoQDBA.Text, txtTenBiCanBiCao.Text, dFrom, dTo, Convert.ToDecimal(rdbTrangthai.SelectedValue), pageIndex, pageSize);
            int Total = 0;
            if (oDT != null && oDT.Rows.Count > 0)
            {
                Total = Convert.ToInt32(oDT.Rows[0]["CountAll"]);
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, pageSize).ToString();
            }
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
            dgList.DataSource = oDT;
            dgList.DataBind();
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                #region Validate
                if (txtTuNgay.Text != "" && Cls_Comon.IsValidDate(txtTuNgay.Text) == false)
                {
                    lbthongbao.Text = "Bạn phải nhập ngày QĐ/BA từ ngày theo định dạng (dd/MM/yyyy)!";
                    txtTuNgay.Focus();
                    return;
                }
                if (txtDenNgay.Text != "" && Cls_Comon.IsValidDate(txtDenNgay.Text) == false)
                {
                    lbthongbao.Text = "Bạn phải nhập ngày QĐ/BA đến ngày theo định dạng (dd/MM/yyyy)!";
                    txtDenNgay.Focus();
                    return;
                }
                if (txtTuNgay.Text != "" && txtDenNgay.Text != "")
                {
                    DateTime TuNgay = DateTime.Parse(txtTuNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    DateTime DenNgay = DateTime.Parse(txtDenNgay.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                    if (DateTime.Compare(TuNgay, DenNgay) > 0)
                    {
                        lbthongbao.Text = "Ngày QĐ/BA từ ngày phải nhỏ hơn đến ngày!";
                        txtDenNgay.Focus();
                        return;
                    }
                }
                #endregion
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            pnDanhsach.Visible = true;
            pnCapnhat.Visible = false;
            txtMaVuAn.Text = txtTenVuAn.Text = txtTuNgay.Text = txtDenNgay.Text = "";
            rdbTrangthai.SelectedValue = "1";
            hddPageIndex.Value = "1"; dgList.CurrentPageIndex = 0;
            LoadGrid();
        }
        protected void cmdCapnhat_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValidate())
                {
                    return;
                }
                if (dsSelected != null || dsSelected.Rows.Count > 0)
                {
                    decimal vuAnID = 0; AHS_SAUXETXU obj; bool isNew = false; AHS_VUAN vuAn;
                    foreach (DataRow row in dsSelected.Rows)
                    {
                        vuAnID = Convert.ToDecimal(row["ID"].ToString());
                        obj = dt.AHS_SAUXETXU.Where(x => x.VUANID == vuAnID).FirstOrDefault<AHS_SAUXETXU>();
                        if (obj == null)
                        {
                            isNew = true;
                            obj = new AHS_SAUXETXU();
                            obj.NGAYTAO = DateTime.Now;
                            obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        }
                        else
                        {
                            obj.NGAYSUA = DateTime.Now;
                            obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        }
                        obj.VUANID = vuAnID;
                        vuAn = dt.AHS_VUAN.Where(x => x.ID == vuAnID).FirstOrDefault<AHS_VUAN>();
                        if (vuAn != null)
                        {
                            if (vuAn.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)// lưu sơ thẩm
                            {
                                obj.ST_ISRUTKN = 1;
                                obj.ST_NGAYRUT = txtNgayRutKN.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayRutKN.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.ST_NOIDUNG = txtNoiDung.Text.Trim();
                            }
                            else// Lưu ở phúc thẩm
                            {
                                obj.PT_ISRUTKN = 1;
                                obj.PT_NGAYRUT = txtNgayRutKN.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgayRutKN.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                                obj.PT_NOIDUNG = txtNoiDung.Text.Trim();
                            }
                        }
                        if (isNew)
                        {
                            dt.AHS_SAUXETXU.Add(obj);
                        }
                        dt.SaveChanges();
                    }
                    pnCapnhat.Visible = false;
                    pnDanhsach.Visible = true;
                    txtMaVuAn.Text = txtTenVuAn.Text = txtTuNgay.Text = txtDenNgay.Text = "";
                    rdbTrangthai.SelectedValue = "1";
                    hddPageIndex.Value = "1"; dgList.CurrentPageIndex = 0;
                    LoadGrid();
                }
                else
                {
                    lbthongBaoUpdate.Text = "Không có vụ án cần rút kinh nghiệm!";
                }
            }
            catch (Exception ex) { lbthongBaoUpdate.Text = ex.Message; }
        }
        private bool CheckValidate()
        {
            if (Cls_Comon.IsValidDate(txtNgayRutKN.Text) == false)
            {
                lbthongBaoUpdate.Text = "Bạn phải nhập ngày rút kinh nghiệm theo định dạng (dd/MM/yyyy).";
                txtNgayRutKN.Focus();
                return false;
            }
            int LengthNoiDung = txtNoiDung.Text.Trim().Length;
            if (LengthNoiDung == 0)
            {
                lbthongBaoUpdate.Text = "Bạn chưa nhập nội dung rút kinh nghiệm. Hãy nhập lại!";
                txtNoiDung.Focus();
                return false;
            }
            if (LengthNoiDung > 500)
            {
                lbthongBaoUpdate.Text = "Nội dung rút kinh nghiệm không quá 500 ký tự. Hãy nhập lại!";
                txtNoiDung.Focus();
                return false;
            }
            return true;
        }
        private DataTable CreateTableSelected()
        {
            dsSelected = new DataTable();
            dsSelected.Columns.Add("ID", typeof(decimal));
            dsSelected.Columns.Add("MAVUAN", typeof(string));
            dsSelected.Columns.Add("TENVUAN", typeof(string));
            return dsSelected;
        }
        private void LoadGridSelected()
        {
            lbthongBaoUpdate.Text = "";
            if (dsSelected != null && dsSelected.Rows.Count > 0)
            {
                // load thông tin
                decimal VuAnID = Convert.ToDecimal(dsSelected.Rows[0]["ID"].ToString());
                AHS_SAUXETXU sx = dt.AHS_SAUXETXU.Where(x => x.VUANID == VuAnID).FirstOrDefault<AHS_SAUXETXU>();
                if (sx != null)
                {
                    AHS_VUAN va = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault<AHS_VUAN>();
                    if (va != null)
                    {
                        if (va.TOAANID == va.TOAPHUCTHAMID)// lưu sơ thẩm
                        {
                            txtNgayRutKN.Text = sx.ST_NGAYRUT + "" == "" ? "" : ((DateTime)sx.ST_NGAYRUT).ToString("dd/MM/yyyy");
                            txtNoiDung.Text = sx.ST_NOIDUNG;
                        }
                        else// Lưu ở phúc thẩm
                        {
                            txtNgayRutKN.Text = sx.PT_NGAYRUT + "" == "" ? "" : ((DateTime)sx.PT_NGAYRUT).ToString("dd/MM/yyyy");
                            txtNoiDung.Text = sx.PT_NOIDUNG;
                        }
                    }
                }
                else
                {
                    txtNgayRutKN.Text = txtNoiDung.Text = "";
                }
                #region "Xác định số lượng trang"
                int Total = Convert.ToInt32(dsSelected.Rows.Count);
                hddTotalPageSelected.Value = Cls_Comon.GetTotalPage(Total, dgListSelected.PageSize).ToString();
                lstSobanghiTSelected.Text = lstSobanghiBSelected.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPageSelected.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPageSelected, hddPageIndexSelected, lbTFirstSelected, lbBFirstSelected,
                    lbTLastSelected, lbBLastSelected, lbTNextSelected, lbBNextSelected, lbTBackSelected, lbBBackSelected,
                    lbTStep1Selected, lbBStep1Selected, lbTStep2Selected, lbBStep2Selected, lbTStep3Selected, lbBStep3Selected,
                    lbTStep4Selected, lbBStep4Selected, lbTStep5Selected, lbBStep5Selected, lbTStep6Selected, lbBStep6Selected);
                #endregion
                dgListSelected.DataSource = dsSelected;
                dgListSelected.DataBind();
            }
        }
       
        #region Phân trang danh sách đã chọn
        protected void lbTBackSelected_Click(object sender, EventArgs e)
        {
            try
            {
                dgListSelected.CurrentPageIndex = Convert.ToInt32(hddPageIndexSelected.Value) - 2;
                hddPageIndexSelected.Value = (Convert.ToInt32(hddPageIndexSelected.Value) - 1).ToString();
                LoadGridSelected();
            }
            catch (Exception ex) { lbthongBaoUpdate.Text = ex.Message; }
        }
        protected void lbTFirstSelected_Click(object sender, EventArgs e)
        {
            try
            {
                dgListSelected.CurrentPageIndex = 0;
                hddPageIndexSelected.Value = "1";
                LoadGridSelected();
            }
            catch (Exception ex) { lbthongBaoUpdate.Text = ex.Message; }
        }
        protected void lbTStepSelected_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgListSelected.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndexSelected.Value = lbCurrent.Text;
                LoadGridSelected();
            }
            catch (Exception ex) { lbthongBaoUpdate.Text = ex.Message; }
        }
        protected void lbTLastSelected_Click(object sender, EventArgs e)
        {
            try
            {
                dgListSelected.CurrentPageIndex = Convert.ToInt32(hddTotalPageSelected.Value) - 1;
                hddPageIndexSelected.Value = Convert.ToInt32(hddTotalPageSelected.Value).ToString();
                LoadGridSelected();
            }
            catch (Exception ex) { lbthongBaoUpdate.Text = ex.Message; }
        }
        protected void lbTNextSelected_Click(object sender, EventArgs e)
        {
            try
            {
                dgListSelected.CurrentPageIndex = Convert.ToInt32(hddPageIndexSelected.Value);
                hddPageIndexSelected.Value = (Convert.ToInt32(hddPageIndexSelected.Value) + 1).ToString();
                LoadGridSelected();
            }
            catch (Exception ex) { lbthongBaoUpdate.Text = ex.Message; }
        }
        #endregion
        protected void cmdTTSauXetXu_Click(object sender, EventArgs e)
        {
            if (dsSelected != null) dsSelected.Clear();
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    DataRow row = dsSelected.NewRow();
                    row["ID"] = Item.Cells[0].Text;
                    row["MAVUAN"] = Item.Cells[3].Text;
                    row["TENVUAN"] = Item.Cells[4].Text;
                    dsSelected.Rows.Add(row);
                }
            }
            if (dsSelected == null || dsSelected.Rows.Count == 0)
            {
                lbthongbao.Text = "Bạn chưa chọn vụ án cần rút kinh nghiệm. Hãy chọn lại!";
                return;
            }
            else
            {
                hddPageIndexSelected.Value = "1";
                dgList.CurrentPageIndex = 0;
                LoadGridSelected();
            }
            pnDanhsach.Visible = false;
            pnCapnhat.Visible = true;
        }
        public void loadedit(decimal ID, String MAGIAIDOAN)
        {
            AHS_SAUXETXU oND;
            if (MAGIAIDOAN == "Sơ thẩm")
                 oND = dt.AHS_SAUXETXU.Where(x => x.VUANID == ID && x.ST_ISRUTKN == 1).FirstOrDefault();
            else
                oND = dt.AHS_SAUXETXU.Where(x => x.VUANID == ID && x.PT_ISRUTKN == 1).FirstOrDefault();

            if (oND != null)
            {
                if (dsSelected != null) dsSelected.Clear();
                AHS_VUAN oVA = dt.AHS_VUAN.Where(x => x.ID == oND.VUANID).FirstOrDefault();

                DataRow row = dsSelected.NewRow();
                row["ID"] = oVA.ID;
                row["MAVUAN"] = oVA.MAVUAN;
                row["TENVUAN"] = oVA.TENVUAN;
                dsSelected.Rows.Add(row);
                
                hddPageIndexSelected.Value = "1";
                dgList.CurrentPageIndex = 0;
                LoadGridSelected();

                pnDanhsach.Visible = false;
                pnCapnhat.Visible = true;
                txtNgayRutKN.Text = ((DateTime)oND.ST_NGAYRUT).ToString("dd/MM/yyyy", cul);
                txtNoiDung.Text = oND.ST_NOIDUNG;
            }
        }
        public void xoa(decimal ID, String MAGIAIDOAN)
        {
            AHS_SAUXETXU oND;
            if (MAGIAIDOAN == "Sơ thẩm")
                oND = dt.AHS_SAUXETXU.Where(x => x.VUANID == ID && x.ST_ISRUTKN == 1).FirstOrDefault();
            else
                oND = dt.AHS_SAUXETXU.Where(x => x.VUANID == ID && x.PT_ISRUTKN == 1).FirstOrDefault();

            if (oND != null)
            {
                dt.AHS_SAUXETXU.Remove(oND);
                dt.SaveChanges();
                lbthongbao.Text = "Xóa thành công!";
            }
            rdbTrangthai.SelectedValue = "1";
            hddPageIndex.Value = "1"; dgList.CurrentPageIndex = 0;
            LoadGrid();
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            string[] arr = e.CommandArgument.ToString().Split('#');
            decimal ND_id = Convert.ToDecimal(arr[0]);
            string MAGD = arr[1];
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    loadedit(ND_id,MAGD);
                    //hddid.Value = ND_id + "";
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    //decimal VUANID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                    xoa(ND_id, MAGD);
                   
                    break;
            }

        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                if (hddShowCommand.Value == "False")
                    lblSua.Visible = lbtXoa.Visible = false;
                else
                    lblSua.Visible = lbtXoa.Visible = true;

            }
        }
    }
}