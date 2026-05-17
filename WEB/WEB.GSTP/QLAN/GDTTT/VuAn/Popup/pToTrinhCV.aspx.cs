using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.GDTTT;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.Popup
{
    public partial class pToTrinhCV : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        Decimal CurrentUserID = 0, CongVanID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            CongVanID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");

            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    Load_LoaiTrinh(ddlLoaitrinh, false);
                    LoadLanhdao(ddlLoaitrinh, ddlLanhdao, lttLanhDao);

                    dropCapTrinhTiep.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                    dropLDrinhTiep.Items.Insert(0, new ListItem("--- Chọn ---", "0"));

                    //txt_NgayToTrinh.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    // SetNewSoToTrinh();

                    if (Request["vid"] != null)
                    {
                        try
                        {
                            decimal CongvanID = Convert.ToDecimal(Request["vid"] + "");

                            LoadThongTinCongvan(CongvanID);
                            LoadDsToTrinh();
                        }
                        catch (Exception ex)
                        {
                            lbthongbao.Text = "Lỗi: " + ex.Message;
                            lbthongbao.ForeColor = System.Drawing.Color.Red;
                        }
                    }
                }
            }
        }

        //---------------------------     
        void LoadThongTinCongvan(Decimal CongvanID)
        {
            GDTTT_VUAN_TRAODOICONGVAN oT = dt.GDTTT_VUAN_TRAODOICONGVAN.Where(x => x.ID == CongvanID).FirstOrDefault();
            if (oT != null)
            {
                if (!String.IsNullOrEmpty(oT.NOIDUNG + ""))
                    lttNoiDungCV.Text = oT.NOIDUNG;

                txtCV_SoCV.Text = oT.SOCV;
                txtCV_NgayCV.Text = (String.IsNullOrEmpty(oT.NGAYCV + "") || (oT.NGAYCV == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYCV).ToString("dd/MM/yyyy", cul);

                txtCV_SoThuLy.Text = oT.SOTHULY;
                txtCV_NgayThuLy.Text = (String.IsNullOrEmpty(oT.NGAYTHULY + "") || (oT.NGAYTHULY == DateTime.MinValue)) ? "" : ((DateTime)oT.NGAYTHULY).ToString("dd/MM/yyyy", cul);

                if (oT.DONVIGUIID == 0)
                    label_DonViGuiCV.Text = "Đơn vị chuyển CV";

                lttTTV.Text = oT.TTV_HOTEN;
                lttDonviGuiCV.Text = oT.TENDONVIGUICV;

                txt_NgayToTrinh.Text = (String.IsNullOrEmpty(oT.TT_NGAYTOTRINH + "") || (oT.TT_NGAYTOTRINH == DateTime.MinValue)) ? "" : ((DateTime)oT.TT_NGAYTOTRINH).ToString("dd/MM/yyyy", cul);// DateTime.Now.ToString("dd/MM/yyyy", cul);
                txt_SoToTrinh.Text = oT.TT_SOTOTRINH + "";
                if (!String.IsNullOrEmpty(oT.TT_SOTOTRINH))
                    txt_SoToTrinh.Enabled = false;
                if (!String.IsNullOrEmpty(txt_NgayToTrinh.Text))
                    txt_NgayToTrinh.Enabled = false;
            }
        }
        //-------------------------------
        private void LoadDsToTrinh()
        {
            DataTable tbl = GetData();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rpt.DataSource = tbl;
                rpt.DataBind();
                rpt.Visible = true;
                cmdPrinDS.Visible = true;
            }
            else
            {
                rpt.Visible = false;
                cmdPrinDS.Visible = false;
            }
        }
        DataTable GetData()
        {
            int count_row = 1;
            DataTable tblData = null;

            GDTTT_VUAN_TRAODOICONGVAN_BL oBL = new GDTTT_VUAN_TRAODOICONGVAN_BL();
            DataTable tbl = oBL.ToTrinhCV_GetAll(CongVanID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                tbl.Columns.Add("IsShow", typeof(Int16));
                tbl.Columns.Add("Rowspan", typeof(Int16));

                #region Tao du lieu cho column LanTrinh 
                int lantrinh = 1, IsTrinhLai = 0;
                DataRow[] arr = tbl.Select("", "NgayTrinh asc,ID asc, IsTrinhLai asc");
                foreach (DataRow row in arr)
                {
                    IsTrinhLai = Convert.ToInt16(row["IsTrinhLai"] + "");

                    //bat dau vong trinh moi
                    if (IsTrinhLai == 1)
                        lantrinh++;
                    row["LanTrinh"] = lantrinh;
                }
                #endregion

                //----------------------------
                DataView view = new DataView(tbl);
                view.Sort = "LanTrinh desc, NgayTrinh desc, ThuTuCapTrinh desc";
                tblData = view.ToTable();

                //----------------------------
                int count_index = 1;
                count_row = 1;
                for (int i = 1; i <= lantrinh; i++)
                {
                    count_index = 1;
                    arr = tblData.Select("LanTrinh=" + i.ToString());
                    count_row = arr.Length;
                    foreach (DataRow rowdata in arr)
                    {
                        rowdata["Rowspan"] = count_row;
                        if (count_index == 1)
                            rowdata["IsShow"] = 1;
                        else rowdata["IsShow"] = 0;
                        count_index++;
                    }
                }
            }
            return tblData;
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dv = (DataRowView)e.Item.DataItem;
                Literal lttLanTrinh = (Literal)e.Item.FindControl("lttLanTrinh");

                if (dv["IsShow"].ToString() == "1")
                {
                    lttLanTrinh.Visible = true;
                    lttLanTrinh.Text = "<td rowspan='" + dv["Rowspan"].ToString() + "' style='text-align:center;'>" + dv["LanTrinh"].ToString() + "</td>";
                }
                else lttLanTrinh.Visible = false;
            }
        }

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal ToTrinhID = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    Load_Totrinh(ToTrinhID);
                    break;
                case "Xoa":
                    //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //if (oPer.XOA == false || cmdUpdate.Enabled == false)
                    //{
                    //    lbthongbao.Text = "Bạn không có quyền xóa!";
                    //    return;
                    //}
                    Xoa_ToTrinh(ToTrinhID);
                    LoadDsToTrinh();
                    ResetControl();
                    hddReloadParent.Value = "1";
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                    break;
            }
        }
        void Load_Totrinh(decimal ToTrinhID)
        {
            hddid.Value = ToTrinhID.ToString();

            GDTTT_TRAODOICV_TOTRINH oT = dt.GDTTT_TRAODOICV_TOTRINH.Where(x => x.ID == ToTrinhID).FirstOrDefault();
            if (oT != null)
            {
                Cls_Comon.SetValueComboBox(ddlLoaitrinh, oT.TINHTRANGID);
                LoadLanhdao(ddlLoaitrinh, ddlLanhdao, lttLanhDao);
                if (ddlLanhdao.Visible && oT.LANHDAOID > 0)
                    Cls_Comon.SetValueComboBox(ddlLanhdao, oT.LANHDAOID);

                if (oT.NGAYTRINH != null) txtNgaytrinh.Text = ((DateTime)oT.NGAYTRINH).ToString("dd/MM/yyyy", cul);
                if (oT.NGAYTRA != null) txtNgaytra.Text = ((DateTime)oT.NGAYTRA).ToString("dd/MM/yyyy", cul);

                txtGhichu.Text = oT.GHICHU;

                //-------------------------
                if (oT.NGAYLDNHANTOTRINH != null) txtNgayLDNhanToTrinh.Text = ((DateTime)oT.NGAYLDNHANTOTRINH).ToString("dd/MM/yyyy", cul);

                //decimal LoaiYKien = (String.IsNullOrEmpty(oT.LOAIYKIEN + "")) ? 0 :(decimal)oT.LOAIYKIEN;
                //rdLoaiYKien.SelectedValue = LoaiYKien.ToString();
                //if (LoaiYKien == 2)
                //{
                //    pnTrinhLDTiep.Visible = true;
                //    Load_LoaiTrinh(dropCapTrinhTiep, true);
                //    Cls_Comon.SetValueComboBox(dropCapTrinhTiep, oT.CAPTRINHTIEP);

                //    LoadLanhdao(dropCapTrinhTiep, dropLDrinhTiep, lttHoTenLDTiep);
                //    Cls_Comon.SetValueComboBox(dropLDrinhTiep, oT.TRINHTIEP_LANHDAO_ID);
                //}
                //else
                pnTrinhLDTiep.Visible = false;
                txtYkien.Text = oT.YKIEN;
            }
        }
        void Xoa_ToTrinh(decimal ToTrinhID)
        {
            GDTTT_TRAODOICV_TOTRINH oTDel = dt.GDTTT_TRAODOICV_TOTRINH.Where(x => x.ID == ToTrinhID).FirstOrDefault();
            dt.GDTTT_TRAODOICV_TOTRINH.Remove(oTDel);
            dt.SaveChanges();
            //--------------------
            try
            {
                Update_CongVan();
                dt.SaveChanges();
            }
            catch (Exception ex) { }
            //----------------------------------

        }

        //protected void chkEdit_CheckedChanged(object sender, EventArgs e)
        //{
        //    if(chkEdit.Checked)
        //    {
        //        txt_SoToTrinh.Enabled = true;
        //        txt_NgayToTrinh.Enabled = true;
        //    }
        //    else
        //    {
        //        txt_SoToTrinh.Enabled = false;
        //        txt_NgayToTrinh.Enabled = false;
        //    }
        //}

        //protected void txt_NgayToTrinh_TextChanged(object sender, EventArgs e)
        //{
        //    SetNewSoToTrinh();
        //}

        //void SetNewSoToTrinh()
        //{
        //    DateTime NgayLapTT = (String.IsNullOrEmpty(txt_NgayToTrinh.Text.Trim())) ? DateTime.Now : DateTime.Parse(this.txt_NgayToTrinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
        //    GDTTT_VUAN_BL obj = new GDTTT_VUAN_BL();
        //    Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID]);

        //    try
        //    {
        //        decimal STT = obj.GetNewSoToTrinh(PhongBanID, NgayLapTT);
        //        txt_SoToTrinh.Text = STT.ToString();
        //    }
        //    catch (Exception ex) { txt_SoToTrinh.Text = "1"; }
        //}

        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            //String SessionName = "GDTTT_ReportPL".ToUpper();
            //Session[SS_TK.TENBAOCAO] = "Danh sách tờ trình".ToUpper();
            //int count_row = 1;
            //DataTable tblData = null;
            //string strvid = Request["vid"] + "";
            //decimal CongVanID = Convert.ToDecimal(strvid);
            //GDTTT_VUAN_BL oBL = new GDTTT_VUAN_BL();
            //DataTable tbl = oBL.VUAN_TOTRINH(CongVanID);
            //if (tbl != null && tbl.Rows.Count > 0)
            //{
            //    tbl.Columns.Add("IsShow", typeof(Int16));
            //    tbl.Columns.Add("Rowspan", typeof(Int16));
            //    tblData = tbl.Clone();               

            //    #region Tao du lieu cho column LanTrinh 
            //    int lantrinh = 1, IsTrinhLai = 0;
            //    DataRow[] arr = tbl.Select("", "NgayTrinh asc, IsTrinhLai asc");
            //    foreach (DataRow row in arr)
            //    {
            //        IsTrinhLai = Convert.ToInt16(row["IsTrinhLai"] + "");
            //        count_row++;

            //        if (IsTrinhLai == 1)
            //        {
            //            //bat dau vong trinh moi
            //            lantrinh++;
            //            count_row = 1;
            //        }
            //        row["LanTrinh"] = lantrinh;
            //    }
            //    #endregion
            //}
            //if (tbl != null && tbl.Rows.Count > 0)
            //    Session[SessionName] = tbl;
        }
        protected void ddlLoaitrinh_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadLanhdao(ddlLoaitrinh, ddlLanhdao, lttLanhDao);
        }

        private void ResetControl()
        {
            if (!string.IsNullOrEmpty(txt_SoToTrinh.Text))
                txt_SoToTrinh.Enabled = false;
            if (!string.IsNullOrEmpty(txt_NgayToTrinh.Text))
                txt_NgayToTrinh.Enabled = false;

            txtNgaytra.Text = txtNgaytrinh.Text = txtGhichu.Text = txtYkien.Text = "";
            ddlLoaitrinh.SelectedIndex = 0;
            LoadLanhdao(ddlLoaitrinh, ddlLanhdao, lttLanhDao);

            chkTrinhLai.Checked = false;
            hddid.Value = "0";
            pnTrinhLDTiep.Visible = false;
            dropCapTrinhTiep.SelectedIndex = 0;
            LoadLanhdao(dropCapTrinhTiep, dropLDrinhTiep, lttHoTenLDTiep);

            //rdLoaiYKien.SelectedIndex = 0;
        }

        public void cmdLamMoi_Click(object sender, EventArgs e)
        {
            ResetControl();
        }
        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                string strvid = Request["vid"] + "";
                decimal CongVanID = Convert.ToDecimal(strvid);
                //----------------------------------
                Boolean IsUpdate = false;
                GDTTT_TRAODOICV_TOTRINH oT;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oT = new GDTTT_TRAODOICV_TOTRINH();
                    IsUpdate = false;
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oT = dt.GDTTT_TRAODOICV_TOTRINH.Where(x => x.ID == ID).FirstOrDefault();
                    if (oT != null)
                        IsUpdate = true;
                    else
                    {
                        IsUpdate = false;
                        oT = new GDTTT_TRAODOICV_TOTRINH();
                    }
                }

                //---------------------
                oT.CONGVANID = CongVanID;
                oT.LANHDAOID = (ddlLanhdao.Visible) ? Convert.ToDecimal(ddlLanhdao.SelectedValue) : 0;
                oT.NGAYTRINH = oT.NGAYDK = (String.IsNullOrEmpty(txtNgaytrinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaytrinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.NGAYTRA = (String.IsNullOrEmpty(txtNgaytra.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaytra.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                oT.YKIEN = txtYkien.Text;
                oT.GHICHU = txtGhichu.Text;
                oT.TINHTRANGID = Convert.ToDecimal(ddlLoaitrinh.SelectedValue);
                oT.ISKETQUA = (String.IsNullOrEmpty(txtNgaytra.Text)) ? 0 : 1;
                oT.ISTRINHLAI = chkTrinhLai.Checked ? 1 : 0;
                //------------------------
                oT.NGAYLDNHANTOTRINH = (String.IsNullOrEmpty(txtNgayLDNhanToTrinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayLDNhanToTrinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                //----------------------------------
                //oT.LOAIYKIEN = Convert.ToDecimal(rdLoaiYKien.SelectedValue);
                oT.CAPTRINHTIEP = Convert.ToDecimal(dropCapTrinhTiep.SelectedValue);
                oT.TRINHTIEP_LANHDAO_ID = (!dropLDrinhTiep.Visible) ? 0 : Convert.ToDecimal(dropLDrinhTiep.SelectedValue);

                //------------------------------
                Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");

                if (!IsUpdate)
                {
                    oT.LANTRINH = 0;
                    oT.NGAYTAO = DateTime.Now;
                    oT.NGUOITAOID = UserID;
                    oT.NGUOITAO_HOTEN = UserName;
                    dt.GDTTT_TRAODOICV_TOTRINH.Add(oT);
                }
                dt.SaveChanges();
                try
                {
                    Update_CongVan();
                }
                catch (Exception ex) { }

                LoadDsToTrinh();
                ResetControl();
                lbthongbao.Text = "Lưu thành công!";

                hddReloadParent.Value = "1";
                //Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
            }
            catch (Exception ex)
            {
                lbthongbao.ForeColor = System.Drawing.Color.Red;
                lbthongbao.Text = "Lỗi:" + ex.Message;
            }
        }
        void Update_CongVan()
        {
            decimal CongVanID = Convert.ToDecimal(Request["vid"] + "");

            decimal count_tt = 0;
            Decimal max_trangthai_tt = 0;
            String max_ghichu = "";
            DateTime max_ngaytrinh = DateTime.MinValue;

            GDTTT_VUAN_TRAODOICONGVAN_BL oBL = new GDTTT_VUAN_TRAODOICONGVAN_BL();
            DataTable tbl = null;
            try
            {
                tbl = oBL.ToTrinhCV_GetAll(CongVanID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    count_tt = tbl.Rows.Count;
                    max_trangthai_tt = (string.IsNullOrEmpty(tbl.Rows[0]["TinhTrangID"] + "")) ? 2 : Convert.ToDecimal(tbl.Rows[0]["TinhTrangID"] + "");
                    max_ghichu = tbl.Rows[0]["Ghichu"] + "";
                    max_ngaytrinh = (String.IsNullOrEmpty(tbl.Rows[0]["NgayTrinh"] + "")) ? DateTime.MinValue : Convert.ToDateTime(tbl.Rows[0]["NgayTrinh"] + "");
                }
            }
            catch (Exception exx) { }
            //-----------------------
            GDTTT_VUAN_TRAODOICONGVAN oVA = dt.GDTTT_VUAN_TRAODOICONGVAN.Where(x => x.ID == CongVanID).Single();
            if (oVA != null)
            {
                if (string.IsNullOrEmpty(oVA.TT_SOTOTRINH + ""))
                {
                    oVA.TT_SOTOTRINH = txt_SoToTrinh.Text;
                    oVA.TT_NGAYTOTRINH = (String.IsNullOrEmpty(txt_NgayToTrinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txt_NgayToTrinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                }
                //-------------------------------
                oVA.TRANGTHAIID = max_trangthai_tt;
                oVA.LASTNGAYTRINH = max_ngaytrinh;
                oVA.QUATRINH_GHICHU = max_ghichu;
                oVA.ISTOTRINH = count_tt;
                dt.SaveChanges();
            }
        }

        //protected void rdLoaiYKien_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    int type = Convert.ToInt16(rdLoaiYKien.SelectedValue);
        //    if (type == 2)
        //    {
        //        pnTrinhLDTiep.Visible = true;
        //        dropLDrinhTiep.Visible = lttHoTenLDTiep.Visible = true;

        //        Load_LoaiTrinh(dropCapTrinhTiep, true);
        //        LoadLanhdao(dropCapTrinhTiep, dropLDrinhTiep, lttHoTenLDTiep);
        //    }
        //    else pnTrinhLDTiep.Visible = false;
        //}
        protected void dropCapTrinhTiep_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadLanhdao(dropCapTrinhTiep, dropLDrinhTiep, lttHoTenLDTiep);
        }

        //---------------------------------
        void Load_LoaiTrinh(DropDownList drop, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            drop.DataSource = dt.GDTTT_DM_TINHTRANG.Where(x => x.GIAIDOAN == 2 && x.ID != 100 && x.HIEULUC == 1).OrderBy(x => x.THUTU).ToList();
            drop.DataTextField = "TENTINHTRANG";
            drop.DataValueField = "ID";
            drop.DataBind();
            if (ShowChangeAll)
                drop.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }

        private void LoadLanhdao(DropDownList dropCapTrinh, DropDownList dropLanhDao, Literal lttHoTen)
        {
            decimal TrangThaiID = Convert.ToDecimal(dropCapTrinh.SelectedValue);
            dropLanhDao.Items.Clear();
            if (TrangThaiID > 0)
            {
                lttHoTen.Visible = true;
                dropLanhDao.Visible = true;
                GDTTT_DON_BL objDon = new GDTTT_DON_BL();
                DM_CANBO_BL objCB = new DM_CANBO_BL();

                Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                decimal PBID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
                decimal CongVanID = Convert.ToDecimal(Request["vid"] + "");
                GDTTT_VUAN oT = dt.GDTTT_VUAN.Where(x => x.ID == CongVanID).FirstOrDefault();

                GDTTT_DM_TINHTRANG oTT = dt.GDTTT_DM_TINHTRANG.Where(x => x.ID == TrangThaiID).FirstOrDefault();
                dropLanhDao.Items.Clear();
                switch (oTT.MA)
                {
                    case "07"://Phó chánh án
                        lttHoTen.Text = "Phó chánh án";
                        LoadChanhAn(dropLanhDao);
                        break;
                    case "06":
                        //Tham phan
                        lttHoTen.Text = "Thẩm phán";
                        LoadThamPhan(dropLanhDao);
                        break;
                    case "04":
                        //Phó Vụ trưởng
                        lttHoTen.Text = "Phó Vụ trưởng";
                        LoadPhoVT(dropLanhDao);
                        break;
                    case "05":
                        //Vụ trưởng
                        lttHoTen.Text = "Vụ trưởng";
                        LoadVuTruong(dropLanhDao);
                        break;
                    default:
                        lttHoTen.Visible = false;
                        dropLanhDao.Visible = false;
                        break;
                }
            }
            else
            {
                dropLanhDao.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
                lttHoTen.Text = "Lãnh đạo";
            }
        }
        void LoadChanhAn(DropDownList dropLanhDao)
        {
            DM_CANBO_BL objCB = new DM_CANBO_BL();
            dropLanhDao.Items.Clear();
            Decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal PBID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            decimal CongVanID = Convert.ToDecimal(Request["vid"] + "");
            DataTable oCAPCA = objCB.DM_CANBO_GETBYDONVI_CHUCVU(DonViID, ENUM_CHUCVU.CHUCVU_PCA);
            dropLanhDao.DataSource = oCAPCA;
            dropLanhDao.DataTextField = "MA_TEN";
            dropLanhDao.DataValueField = "ID";
            dropLanhDao.DataBind();
        }
        protected void LoadThamPhan(DropDownList drop)
        {
            drop.Items.Clear();
            Boolean IsLoadAll = false;
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();

            Decimal CanboID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_CANBOID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_CANBOID] + "");
            try
            {
                DM_CANBO oCB = dt.DM_CANBO.Where(x => x.ID == CanboID).Single();
                if (oCB.CHUCDANHID != null && oCB.CHUCDANHID != 0)
                {
                    DM_DATAITEM oCD = dt.DM_DATAITEM.Where(x => x.ID == oCB.CHUCDANHID).FirstOrDefault();
                    if (oCD.MA == "TPTATC")
                        drop.Items.Add(new ListItem(oCB.HOTEN, oCB.ID.ToString()));
                    else
                        IsLoadAll = true;
                }
                else
                    IsLoadAll = true;
            }
            catch (Exception ex) { IsLoadAll = true; }
            if (IsLoadAll)
            {
                DataTable tbl = oBL.CANBO_GETBYDONVI(ToaAnID, ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    drop.DataSource = tbl;
                    drop.DataValueField = "ID";
                    drop.DataTextField = "Hoten";
                    drop.DataBind();
                    drop.Items.Insert(0, new ListItem("Chọn", "0"));
                }
            }
        }
        void LoadPhoVT(DropDownList drop)
        {
            drop.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

            DataTable tblLanhDao = obj.DM_CANBO_GetAllVuTruong_PVT(PhongBanID);
            if (tblLanhDao != null && tblLanhDao.Rows.Count > 0)
            {
                drop.DataSource = tblLanhDao;
                drop.DataValueField = "ID";
                drop.DataTextField = "MA_TEN";
                drop.DataBind();
                drop.Items.Insert(0, new ListItem("Chọn", "0"));
            }
            else
                drop.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        void LoadVuTruong(DropDownList drop)
        {
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            Decimal DonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");

            GDTTT_DON_BL objDon = new GDTTT_DON_BL();
            DataTable tblVT = objDon.CANBO_GETBYDONVI_2CHUCVU(DonViID, PhongBanID, ENUM_CHUCVU.CHUCVU_VT, ENUM_CHUCVU.CHUCVU_VT);
            drop.DataSource = tblVT;
            drop.DataTextField = "MA_TEN";
            drop.DataValueField = "ID";
            drop.DataBind();
            if (drop.Items.Count == 0)
                drop.Items.Insert(0, new ListItem("Chọn", "0"));
        }
        //---------------------------------
    }
}