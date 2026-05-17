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


namespace WEB.GSTP.QLAN.GDTTT.VuAn
{
    public partial class EditCVTraoDoi : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public Decimal CongVanID = 0, NguoiTGTTID = 0;
        public String NgayXayRaVuAn;
        public int CurrentYear = 0;
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentYear = DateTime.Now.Year;
            CongVanID = (String.IsNullOrEmpty(Request["vID"] + "")) ? 0 : Convert.ToDecimal(Request["vID"] + "");
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    try
                    {
                        cmdXoaKQ.Visible = false;
                        LoadDropToaAn();
                        LoadTTVTheoPhongBan();
                        if (CongVanID == 0)
                        {
                            dropToaAn.SelectedIndex = 1;
                            txtDonViChuyenCV.Visible = lblTenDV.Visible = lttValidTenDV.Visible = false;
                            // GetNewSoCV_GiaiQuyet();
                            txtNgayCV.Text = txtNgayThuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
                        }
                        else
                        {
                            hddCurrID.Value = CongVanID.ToString();
                            LoadInfoCongVan();
                        }

                        LoadDsToTrinh();
                    }
                    catch (Exception ex) { }

                }
            }
        }
        void LoadDropToaAn()
        {
            dropToaAn.Items.Clear();
            DM_TOAAN_BL oTABL = new DM_TOAAN_BL();
            DataTable dtTA = oTABL.DM_TOAAN_GETBYNOTCUR(0, 0);
            dropToaAn.DataSource = dtTA;
            dropToaAn.DataTextField = "MA_TEN";
            dropToaAn.DataValueField = "ID";
            dropToaAn.DataBind();
            //dropToaAn.Items.Insert(0, new ListItem("Chọn", "0"));
            dropToaAn.Items.Insert(0, new ListItem("Ngoài Tòa", "0"));
        }
        void LoadTTVTheoPhongBan()
        {
            dropTTV.Items.Clear();
            DM_CANBO_BL obj = new DM_CANBO_BL();
            Decimal PhongBanID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            DataTable tbl = obj.DM_CANBO_GetTTVTheoPhongBan(PhongBanID, "TTV");
            if (tbl != null && tbl.Rows.Count > 0)
            {
                dropTTV.DataSource = tbl;
                dropTTV.DataValueField = "CanBoID";
                dropTTV.DataTextField = "HoTen";
                dropTTV.DataBind();
            }
            //dropTTV.Items.Insert(0, new ListItem("Không chọn", "0"));
        }

        public void LoadInfoCongVan()
        {
            lbthongbao.Text = "";
            decimal ID = Convert.ToDecimal(hddCurrID.Value);
            try
            {
                GDTTT_VUAN_TRAODOICONGVAN obj = dt.GDTTT_VUAN_TRAODOICONGVAN.Where(x => x.ID == ID).Single();
                if (obj != null)
                {
                    Cls_Comon.SetValueComboBox(dropToaAn, obj.DONVIGUIID);
                    ID = (string.IsNullOrEmpty(obj.DONVIGUIID + "")) ? 0 : (decimal)obj.DONVIGUIID;
                    if (ID > 0)
                    {
                        lblTenDV.Visible = lttValidTenDV.Visible = txtDonViChuyenCV.Visible = lttValidTenDV.Visible = false;
                    }
                    else
                    {
                        lblTenDV.Visible = lttValidTenDV.Visible = txtDonViChuyenCV.Visible = lttValidTenDV.Visible = true;
                        txtDonViChuyenCV.Text = obj.TENDONVIGUICV;
                    }
                    //--------------------------- 
                    Decimal tempID = String.IsNullOrEmpty(obj.TTV_ID + "") ? 0 : (decimal)obj.TTV_ID;
                    Cls_Comon.SetValueComboBox(dropTTV, tempID);

                    txtNgayPhanCongTTV.Text = (String.IsNullOrEmpty(obj.NGAYPHANCONGTTV + "") || (obj.NGAYPHANCONGTTV == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYPHANCONGTTV).ToString("dd/MM/yyyy", cul);

                    //------------------
                    txtNgayThuLy.Text = (String.IsNullOrEmpty(obj.NGAYTHULY + "") || (obj.NGAYTHULY == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                    txtSoThuLy.Text = obj.SOTHULY + "";

                    //------------------
                    txtNgayCV.Text = (String.IsNullOrEmpty(obj.NGAYCV + "") || (obj.NGAYCV == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYCV).ToString("dd/MM/yyyy", cul);
                    txtSoCV.Text = obj.SOCV + "";

                    //------------------
                    txtNgaynhan.Text = (String.IsNullOrEmpty(obj.NGAYNHAN + "") || (obj.NGAYNHAN == DateTime.MinValue)) ? "" : ((DateTime)obj.NGAYNHAN).ToString("dd/MM/yyyy", cul);

                    txtNoiDung.Text = obj.NOIDUNG + "";
                    txtGhiChu.Text = obj.GHICHU + "";

                    //---------------------------
                    txtGQ_SoCV.Text = (String.IsNullOrEmpty(obj.KQ_SOCONGVAN + "") || (obj.KQ_SOCONGVAN == 0)) ? "" : obj.KQ_SOCONGVAN.ToString();
                    txtGQ_NgayCV.Text = (String.IsNullOrEmpty(obj.KQ_NGAYCONGVAN + "") || (obj.KQ_NGAYCONGVAN == DateTime.MinValue)) ? "" : ((DateTime)obj.KQ_NGAYCONGVAN).ToString("dd/MM/yyyy", cul);
                    txtGQ_NoiDung.Text = obj.KQ_NOIDUNG + "";
                    txtGQ_GhiChu.Text = obj.KQ_GHICHU + "";
                    int loai = string.IsNullOrEmpty(obj.KQ_LOAI + "") ? 0 : Convert.ToInt16(obj.KQ_LOAI);
                    rdLoaiKQ.SelectedValue = loai.ToString();
                    if (rdLoaiKQ.SelectedValue == "1")
                    {
                        lbNgay.Text = "Ngày trao đổi";
                        lbSoCV.Visible = txtGQ_SoCV.Visible = true;
                    }
                    else
                    {
                        lbSoCV.Visible = txtGQ_SoCV.Visible = false;
                        lbNgay.Text = "Ngày công văn";
                    }
                    int IsKQ = string.IsNullOrEmpty(obj.ISKETQUAGQ + "") ? 0 : Convert.ToInt16(obj.ISKETQUAGQ + "");
                    if (IsKQ > 0)
                        cmdXoaKQ.Visible = true;
                }
            }
            catch (Exception ex) { }
        }

        public void cmdXoaKQ_Click(object sender, EventArgs e)
        {
            GDTTT_VUAN_TRAODOICONGVAN obj = new GDTTT_VUAN_TRAODOICONGVAN();
            bool IsUpdate = false; Decimal CurrCongVanID = (String.IsNullOrEmpty(hddCurrID.Value)) ? 0 : Convert.ToDecimal(hddCurrID.Value + "");

            if (CurrCongVanID > 0)
            {
                try
                {
                    obj = dt.GDTTT_VUAN_TRAODOICONGVAN.Where(x => x.ID == CurrCongVanID).Single<GDTTT_VUAN_TRAODOICONGVAN>();
                    if (obj != null)
                        IsUpdate = true;
                }
                catch (Exception ex) { }
            }
            if (IsUpdate)
            {
                obj.KQ_GHICHU = obj.KQ_NOIDUNG = "";
                obj.KQ_SOCONGVAN = 0;
                obj.KQ_NGAYCONGVAN = null;
                obj.ISKETQUAGQ = 0;
                dt.SaveChanges();
                //----------------
                txtGQ_NgayCV.Text = "";
                txtGQ_SoCV.Text = "";
                txtGQ_NoiDung.Text = "";
                txtGQ_GhiChu.Text = "";

                cmdXoaKQ.Visible = true;
                lttMsgKQ.Text = "Xóa kết quả giải quyết thành công!";
            }
        }

        void SaveData()
        {
            /*Lưu ý: Vu an duoc coi la co ho so khi da co phieu nhan.*/
            GDTTT_VUAN_TRAODOICONGVAN obj = new GDTTT_VUAN_TRAODOICONGVAN();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrCongVanID = (String.IsNullOrEmpty(hddCurrID.Value)) ? 0 : Convert.ToDecimal(hddCurrID.Value + "");
            Decimal SESSION_DonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            Decimal SESSION_PHONGBANID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            DateTime date_temp;
            if (CurrCongVanID > 0)
            {
                try
                {
                    obj = dt.GDTTT_VUAN_TRAODOICONGVAN.Where(x => x.ID == CurrCongVanID).Single<GDTTT_VUAN_TRAODOICONGVAN>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_VUAN_TRAODOICONGVAN();
                }
                catch (Exception ex) { obj = new GDTTT_VUAN_TRAODOICONGVAN(); }
            }
            else
                obj = new GDTTT_VUAN_TRAODOICONGVAN();
            obj.DONVIID = SESSION_DonViID;
            obj.PHONGBANID = SESSION_PHONGBANID;

            if (obj.DONVIGUIID == 0)
                obj.TENDONVIGUICV = txtDonViChuyenCV.Text.Trim();
            else
                obj.TENDONVIGUICV = dropToaAn.SelectedItem.Text;
            obj.DONVIGUIID = Convert.ToDecimal(dropToaAn.SelectedValue);
            //-----------------------------
            obj.TTV_ID = Convert.ToDecimal(dropTTV.SelectedValue);
            obj.TTV_HOTEN = dropTTV.SelectedItem.Text;
            date_temp = (String.IsNullOrEmpty(txtNgayPhanCongTTV.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtNgayPhanCongTTV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYPHANCONGTTV = date_temp;

            //--------------------------------
            date_temp = (String.IsNullOrEmpty(txtNgayThuLy.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayThuLy.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYTHULY = date_temp;
            obj.SOTHULY = txtSoThuLy.Text.Trim();

            obj.SOCV = txtSoCV.Text.Trim();
            date_temp = (String.IsNullOrEmpty(txtNgayCV.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYCV = date_temp;

            date_temp = (String.IsNullOrEmpty(txtNgaynhan.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaynhan.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            obj.NGAYNHAN = date_temp;

            obj.NOIDUNG = txtNoiDung.Text.Trim();
            obj.GHICHU = txtGhiChu.Text.Trim();
            if (!IsUpdate)
            {
                obj.NGAYTAO = DateTime.Now;
                obj.NGUOITAO_ID = UserID;
                obj.NGUOITAO_HOTEN = UserName;
                dt.GDTTT_VUAN_TRAODOICONGVAN.Add(obj);
            }
            dt.SaveChanges();
            hddCurrID.Value = obj.ID.ToString();
        }
        void ClearForm()
        {
            hddCurrID.Value = "0";
            lbthongbao.Text = "";
            txtSoThuLy.Text = txtSoCV.Text = "";
            txtGhiChu.Text = txtNoiDung.Text = "";

            dropTTV.SelectedIndex = dropToaAn.SelectedIndex = 0;
            lblTenDV.Visible = txtDonViChuyenCV.Visible = lttValidTenDV.Visible = false;
            txtDonViChuyenCV.Text = "";
            txtNgayPhanCongTTV.Text = "";
            txtNgaynhan.Text = txtNgayCV.Text = txtNgayThuLy.Text = DateTime.Now.ToString("dd/MM/yyyy");
            //if (CongVanID == 0)
            //    GetNewSoCV_GiaiQuyet();
        }

        //---------------------------------------
        #region Load ds
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDsToTrinh();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        private void LoadDsToTrinh()
        {
            lttMsgDS.Text = "";
            cmdThemToTrinh.Visible = cmdSaveKQ.Visible = true;
            DataTable tbl = GetData();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                rpt.DataSource = tbl;
                rpt.DataBind();
                rpt.Visible = true;
            }
            else
            {
                rpt.Visible = false;
                lttMsgDS.Text = "Chưa có tờ trình!";
            }
            //---------------------
            Decimal CurrID = String.IsNullOrEmpty(hddCurrID.Value + "") ? 0 : Convert.ToDecimal(hddCurrID.Value);
            if (CurrID == 0)
                cmdThemToTrinh.Visible = cmdSaveKQ.Visible =  cmdXoaKQ.Visible = false;
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
                    //Load_Totrinh(ToTrinhID);
                    break;
                case "Xoa":
                    Xoa_ToTrinh(ToTrinhID);
                    LoadDsToTrinh();
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                    break;
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
                Update_CongVan(CongVanID);
                //GDTTT_VUAN_TRAODOICONGVAN objVA = dt.GDTTT_VUAN_TRAODOICONGVAN.Where(x => x.ID == CongVanID).Single();
                //objVA.ISTOTRINH = (string.IsNullOrEmpty(objVA.ISTOTRINH + "")) ? 0 : (objVA.ISTOTRINH - 1);
                //if (objVA.ISTOTRINH == 0)
                //{
                //    decimal THAMTRAVIENID = (string.IsNullOrEmpty(objVA.TTV_ID + "")) ? 0 : (decimal)objVA.TTV_ID;
                //    decimal trangthai = (string.IsNullOrEmpty(objVA.TRANGTHAIID + "")) ? 0 : (decimal)objVA.TRANGTHAIID;
                //    GDTTT_DM_TINHTRANG objTT = dt.GDTTT_DM_TINHTRANG.Where(x => x.ID == trangthai).Single();
                //    if (objTT.GIAIDOAN <= 2)
                //    {
                //        if (THAMTRAVIENID > 0)
                //            objVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.PHANCONG_TTV;
                //        else
                //            objVA.TRANGTHAIID = ENUM_GDTTT_TRANGTHAI.THULY_MOI;
                //    }
                //}
            }
            catch (Exception ex) { }
            //----------------------------------
            dt.SaveChanges();
        }
        void Update_CongVan(decimal CongVanID)
        {
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
                oVA.TRANGTHAIID = max_trangthai_tt;
                oVA.LASTNGAYTRINH = max_ngaytrinh;
                oVA.QUATRINH_GHICHU = max_ghichu;
                oVA.ISTOTRINH = count_tt;
                dt.SaveChanges();
            }
        }
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadDsToTrinh();
            }
            catch (Exception ex) { }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDsToTrinh();
            }
            catch (Exception ex) { }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadDsToTrinh();
            }
            catch (Exception ex) { }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadDsToTrinh();
            }
            catch (Exception ex) { }
        }

        protected void cmdPrint_Click(object sender, EventArgs e)
        {
            //String textsearch = txtTextSearch.Text.Trim();
            //int page_size = 2000000000;
            //String SessionName = "GDTTT_ReportPL".ToUpper();
            //Session[SS_TK.TENBAOCAO] = "Quản lý hồ sơ";

            //GDTTT_QUANLYHS_BL objBL = new GDTTT_QUANLYHS_BL();            
            //DataTable tblData =  objBL.GetAllPaging(VuAnID, textsearch, 1, page_size);
            //if (tblData != null && tblData.Rows.Count > 0)
            //    Session[SessionName] = tblData;
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadDsToTrinh();
            }
            catch (Exception ex) { }
        }
        #endregion
        protected void cmdSearch_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadDsToTrinh();
        }
        //-------------------------------
        //protected void txtNgayCV_TextChanged(object sender, EventArgs e)
        //{
        //    GetNewSoCV();
        //}
        //void GetNewSoCV()
        //{
        //    DateTime Ngay = (DateTime)((String.IsNullOrEmpty(txtNgayCV.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(this.txtNgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));
        //    GDTTT_VUAN_TRAODOICONGVAN_BL objBL = new GDTTT_VUAN_TRAODOICONGVAN_BL();
        //    Decimal SoCV = objBL.GetLastSo(Ngay);
        //    txtSoCV.Text = SoCV + "";
        //}
        //-------------------------------
        //protected void txtGQ_NgayCV_TextChanged(object sender, EventArgs e)
        //{
        //    GetNewSoCV_GiaiQuyet();
        //}

        //void GetNewSoCV_GiaiQuyet()
        //{
        //    Decimal SESSION_DonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
        //    Decimal SESSION_PHONGBANID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");

        //    DateTime Ngay = (DateTime)((String.IsNullOrEmpty(txtGQ_NgayCV.Text.Trim())) ? (DateTime?)DateTime.Now : DateTime.Parse(this.txtGQ_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault));
        //    GDTTT_VUAN_TRAODOICONGVAN_BL objBL = new GDTTT_VUAN_TRAODOICONGVAN_BL();
        //    Decimal SoCV = objBL.GetMaxSoCV_GiaiQuyet(SESSION_PHONGBANID, Ngay);
        //    txtGQ_SoCV.Text = SoCV + "";
        //}

        //-------------------------------
        protected void cmdSave_Click(object sender, EventArgs e)
        {
            try
            {
                SaveData();
                //----------------
                lbthongbao.Text = "Cập nhật thành công!";
                hddIsReloadParent.Value = "1";
                cmdSaveKQ.Visible = true;
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
                //cmdSaveKQ.Visible = false;
            }
        }
        protected void cmdSaveKQ_Click(object sender, EventArgs e)
        {
            try
            {
                SaveKQ();
                //----------------
                lttMsgKQ.Text = "Cập nhật kết quả giải quyết thành công!";
                hddIsReloadParent.Value = "1";
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }

        void SaveKQ()
        {
            GDTTT_VUAN_TRAODOICONGVAN obj = new GDTTT_VUAN_TRAODOICONGVAN();
            bool IsUpdate = false;
            Decimal UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            String UserName = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERNAME] + "")) ? "" : (Session[ENUM_SESSION.SESSION_USERNAME] + "");
            Decimal CurrCongVanID = (String.IsNullOrEmpty(hddCurrID.Value)) ? 0 : Convert.ToDecimal(hddCurrID.Value + "");
            Decimal SESSION_DonViID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_DONVIID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            Decimal SESSION_PHONGBANID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_PHONGBANID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_PHONGBANID] + "");
            DateTime date_temp;
            if (CurrCongVanID > 0)
            {
                try
                {
                    obj = dt.GDTTT_VUAN_TRAODOICONGVAN.Where(x => x.ID == CurrCongVanID).Single<GDTTT_VUAN_TRAODOICONGVAN>();
                    if (obj != null)
                        IsUpdate = true;
                    else
                        obj = new GDTTT_VUAN_TRAODOICONGVAN();
                }
                catch (Exception ex) { obj = new GDTTT_VUAN_TRAODOICONGVAN(); }
            }
            else
                obj = new GDTTT_VUAN_TRAODOICONGVAN();
            if (IsUpdate)
            {
                obj.KQ_LOAI = Convert.ToDecimal(rdLoaiKQ.SelectedValue);
                obj.KQ_SOCONGVAN = (string.IsNullOrEmpty(txtGQ_SoCV.Text.Trim())) ? 0 : Convert.ToDecimal(txtGQ_SoCV.Text);
                date_temp = (String.IsNullOrEmpty(txtGQ_NgayCV.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(txtGQ_NgayCV.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                obj.KQ_NGAYCONGVAN = date_temp;
                obj.KQ_NOIDUNG = txtGQ_NoiDung.Text.Trim();
                obj.KQ_GHICHU = txtGQ_GhiChu.Text.Trim();

                obj.ISKETQUAGQ = 1;
            }
            dt.SaveChanges();
            //------------------------
            int IsKQ = string.IsNullOrEmpty(obj.ISKETQUAGQ + "") ? 0 : Convert.ToInt16(obj.ISKETQUAGQ + "");
            if (IsKQ > 0)
                cmdXoaKQ.Visible = true;
        }
        protected void dropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (dropToaAn.SelectedValue == "0")
                lblTenDV.Visible = txtDonViChuyenCV.Visible = lttValidTenDV.Visible = true;
            else
                lblTenDV.Visible = txtDonViChuyenCV.Visible = lttValidTenDV.Visible = false;
            txtNgayPhanCongTTV.Text = "";
        }

        protected void rdLoaiKQ_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdLoaiKQ.SelectedValue == "1")
            {
                lbNgay.Text = "Ngày công văn";
                lbSoCV.Visible = txtGQ_SoCV.Visible = true;
            }
            else
            {
                lbSoCV.Visible = txtGQ_SoCV.Visible = false;
                lbNgay.Text = "Ngày trao đổi";
            }
        }

        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Response.Redirect("DanhsachAnCV.aspx");
        }
    }
}