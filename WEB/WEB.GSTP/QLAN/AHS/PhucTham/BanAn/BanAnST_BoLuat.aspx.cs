using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
using BL.GSTP.AHS;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.AHS.PhucTham.BanAn
{
    public partial class BanAnST_BoLuat : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        AHS_SOTHAM_BANAN_DIEU_CHITIET_BL objDieuCT = new AHS_SOTHAM_BANAN_DIEU_CHITIET_BL();
        public Decimal BiCanID = 0, BanAnID = 0, VuAnID=0;
        protected void Page_Load(object sender, EventArgs e)
        {
            BiCanID = (String.IsNullOrEmpty(Request["bID"] + "")) ? 0 : Convert.ToDecimal(Request["bID"] + "");
            BanAnID = (String.IsNullOrEmpty(Request["aID"] + "")) ? 0 : Convert.ToDecimal(Request["aID"] + "");
            if (!IsPostBack)
            {
                if (Session[ENUM_LOAIAN.AN_HINHSU] != null)
                {
                    VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
                    hddBanAnID.Value = BanAnID.ToString();

                    LoadDrop();
                    LoadGrid();
                    //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //Cls_Comon.SetButton(cmdThemMoi, oPer.CAPNHAT);
                }
                else
                    Response.Redirect("/Login.aspx");
            }
        }

        void LoadDrop()
        {
            List<AHS_BICANBICAO> lstBC = dt.AHS_BICANBICAO.Where(x => x.VUANID == VuAnID).ToList<AHS_BICANBICAO>();
            if (lstBC != null && lstBC.Count > 0)
            {
                dropBiCao.Items.Clear();
                foreach (AHS_BICANBICAO obj in lstBC)
                    dropBiCao.Items.Add(new ListItem(obj.HOTEN, obj.ID.ToString()));
                try
                {
                    if (Request["bID"] != null)
                        dropBiCao.SelectedValue = Request["bID"] + "";
                }
                catch (Exception ex) { }
            }
            //----------------------------------------
            List<DM_BOLUAT> lst = dt.DM_BOLUAT.Where(x => x.HIEULUC == 1
                            && x.LOAI == ENUM_LOAIVUVIEC.AN_HINHSU.ToString()).ToList<DM_BOLUAT>();
            dropBoLuat.Items.Clear();
            dropBoLuat.Items.Add(new ListItem("--------Chọn--------", "0"));
            if (lst != null && lst.Count > 0)
            {
                foreach (DM_BOLUAT obj in lst)
                    dropBoLuat.Items.Add(new ListItem(obj.TENBOLUAT, obj.ID.ToString()));

                //------------------
                LoadDropNgayBH();
            }
        }

        protected void cmdQuayLai_Click(object sender, EventArgs e)
        {
                Response.Redirect("BanAnSoTham.aspx");
        }
        //protected void cmdSearch_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        hddPageIndex.Value = "1";
        //        LoadGrid();
        //    }
        //    catch (Exception ex) { lbthongbao.Text = ex.Message; }
        //}
        ////protected void cmdThemMoi_Click(object sender, EventArgs e)
        //{
        //    Response.Redirect("AnST_HinhPhat.aspx?bID=" + Request["bID"].ToString() + "&aID=" + BanAnID.ToString());
        //}

        public void LoadGrid()
        {
            decimal bicanID = Convert.ToDecimal(dropBiCao.SelectedValue); 
            int boluatid = Convert.ToInt32(dropBoLuat.SelectedValue);

            string curr_textsearch = "";// txtTenToiDanh.Text.Trim();
            DateTime ngaybh = (boluatid == 0)? DateTime.MinValue: Convert.ToDateTime(dropNgayBH.SelectedValue);

            int page_size = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);
            decimal loaiboluat = Convert.ToDecimal(ENUM_LOAIVUVIEC.AN_HINHSU);
            AHS_SOTHAM_BANAN_DIEU_CHITIET_BL objBL = new AHS_SOTHAM_BANAN_DIEU_CHITIET_BL();
            DataTable tbl = objBL.GetAllPaging(bicanID, BanAnID, boluatid,  curr_textsearch,  pageindex, page_size);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                rpt.DataSource = tbl;
                rpt.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
                rpt.DataSource = null;
                rpt.DataBind();
                lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                // rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
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
        
        protected void cmdThemDieuLuat_Click(object sender, EventArgs e)
        {
            decimal luatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
            String Diem = txtDiem.Text.Trim();
            string Khoan = txtKhoan.Text.Trim();
            String Dieu = txtDieu.Text.Trim();

            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            int Loai_bo_luat = Convert.ToInt32(ENUM_LOAIVUVIEC.AN_HINHSU);
            DataTable tbl = objBL.GetByDK(luatid, Loai_bo_luat, Diem, Khoan, Dieu, 1);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                DataRow row = tbl.Rows[0];
                SaveToiDanh(row);
            }
            hddPageIndex.Value = "1";
            LoadGrid();
        }
        void SaveToiDanh(DataRow rowToiDanh)
        {
            Boolean IsUpdate = false;
            Decimal BiCanID = Convert.ToDecimal(dropBiCao.SelectedValue);
            Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
            decimal toidanhid =  Convert.ToDecimal(rowToiDanh["ID"] + "");
            
            AHS_SOTHAM_BANAN_DIEU_CHITIET obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
            try
            {
                obj = dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Where(x => x.BICANID == BiCanID 
                                                                && x.BANANID == BanAnID
                                                                && x.TOIDANHID == toidanhid).Single<AHS_SOTHAM_BANAN_DIEU_CHITIET>();
                if (obj != null)
                    IsUpdate = true;
                else
                    obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET();
            }
            catch (Exception ex) { obj = new AHS_SOTHAM_BANAN_DIEU_CHITIET(); }
            if (!IsUpdate)
            {
                obj.BANANID = BanAnID;
                obj.BICANID = BiCanID;
                obj.DIEULUATID = boluatid;
                obj.TOIDANHID = toidanhid;
                obj.LOAIHINHPHAT = Convert.ToDecimal(rowToiDanh["Loai"] + "");
                obj.HINHPHATID = 0;
                switch (Convert.ToInt16(obj.LOAIHINHPHAT))
                {
                    case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                        obj.TF_VALUE = 0;
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                        obj.SH_VALUE = 0;
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                        obj.TG_NGAY = 0;
                        obj.TG_THANG = 0;
                        obj.TG_NAM = 0;
                        break;
                    case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                        obj.K_VALUE1 = 0;
                        obj.K_VALUE2 = "";
                        break;
                }
                dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Add(obj);
                dt.SaveChanges();
            }
            lstMsgT.Text = "Lưu điều luật áp dụng cho bị can thành công!";
        }
        
        //protected void Btntimkiem_Click(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        hddPageIndex.Value = "1";
        //        LoadGrid();
        //    }
        //    catch (Exception ex) { lbthongbao.Text = ex.Message; }
        //}

        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    xoa(curr_id);
                    break;
                case "HinhPhat":
                    Response.Redirect("ChonToiDanh.aspx");
                    break;
            }
        }
        
        public void xoa(decimal id)
        {
            //AHS_SOTHAM_CAOTRANG_DIEULUAT obj = dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.ID == id).FirstOrDefault();
            //dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Remove(obj);
            //dt.SaveChanges();

            //hddPageIndex.Value = "1";
            //LoadGrid();
            //lbthongbao.Text = "Xóa thành công!";
        }

        protected void dropBiCao_SelectedIndexChanged(object sender, EventArgs e)
        {
            Response.Redirect("BanAnst_BoLuat.aspx?aID=" + BanAnID + "&bID=" + dropBiCao.SelectedValue);
        }
        protected void dropBoLuat_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadDropNgayBH();
                //LoadGridToiDanh();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        void LoadDropNgayBH()
        {
            int luatid = Convert.ToInt32(dropBoLuat.SelectedValue);
            DM_BOLUAT_TOIDANH_BL obj = new DM_BOLUAT_TOIDANH_BL();
            int Loai_bo_luat = Convert.ToInt32(ENUM_LOAIVUVIEC.AN_HINHSU);
            DataTable tbl = obj.GetByDK(luatid, Loai_bo_luat, "", "", "", 1);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                DataView view = new DataView(tbl);
                DataTable distinct_tbl = view.ToTable(true, "NgayBanHanh");
                dropNgayBH.Items.Clear();
                // dropNgayBH.Items.Add(new ListItem("----------- Chọn ----------", ""));
                String NgayBH = "";
                foreach (DataRow row in distinct_tbl.Rows)
                {
                    NgayBH = String.IsNullOrEmpty(row["NgayBanHanh"] + "") ? "" : Convert.ToDateTime(row["NgayBanHanh"]).ToString("dd/MM/yyyy", cul);
                    if (NgayBH.Length > 0)
                        dropNgayBH.Items.Add(new ListItem(NgayBH, NgayBH));
                }
            }
        }

        string temp = "";
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                //LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                //Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);

                Literal lttHinhPhat = (Literal)e.Item.FindControl("lttHinhPhat");
                HiddenField hddBoLuat = (HiddenField)e.Item.FindControl("hddBoLuat");

                HiddenField hddToiDanh = (HiddenField)e.Item.FindControl("hddToiDanh");
                decimal ToiDanhID = Convert.ToDecimal(hddToiDanh.Value);

                temp = "";
                DataTable tbl = objDieuCT.GetHinhPhat(BanAnID, BiCanID, ToiDanhID);
                if(tbl != null && tbl.Rows.Count>0)
                {  
                    int loai_hinh_phat = 0;
                    string temp_thoigian = "";
                    //, a.TF_value, a.SH_value, a.TG_Nam, a.TG_Thang, a.TG_NGay, a.K_VAlue1, a.K_Value2
                    foreach (DataRow row in tbl.Rows)
                    {
                        temp += "- " + row["TenHinhPhat"].ToString() + ":";
                        loai_hinh_phat = Convert.ToInt16(row["LoaiHinhPhat"] + "");
                        switch (loai_hinh_phat)
                        {
                            case ENUM_LOAIHINHPHAT.DANG_TRUE_FALSE_VALUE:
                                temp += (row["TF_value"].ToString() == "1") ? "Có" : "Không";
                                break;
                            case ENUM_LOAIHINHPHAT.DANG_SO_HOC_VALUE:
                                temp += row["SH_value"] + "";
                                break;
                            case ENUM_LOAIHINHPHAT.DANG_THOI_GIAN_VALUE:
                                temp_thoigian = (String.IsNullOrEmpty(row["TG_Nam"]+"")) ? "": row["TG_Nam"] + " năm ";
                                if (temp_thoigian.Length > 0)
                                    temp_thoigian += ", ";
                                temp_thoigian += (String.IsNullOrEmpty(row["TG_Thang"] + "")) ? "" : row["TG_Thang"] + " tháng";
                                if (temp_thoigian.Length > 0)
                                    temp_thoigian += ", ";
                                temp_thoigian += (String.IsNullOrEmpty(row["TG_NGay"] + "")) ? "" : row["TG_Nam"] + " ngày";
                                //------------------------
                                temp += temp_thoigian;
                                break;
                            case ENUM_LOAIHINHPHAT.DANG_KHAC_VALUE:
                                temp += (String.IsNullOrEmpty(row["K_Value1"] + "")) ? "": row["K_Value1"] +"";
                                temp += (String.IsNullOrEmpty(row["K_Value2"] + "")) ? "" : row["K_Value2"] + "";
                                break;
                        }
                        temp += "<br/>";
                    }
                }
                lttHinhPhat.Text = temp;
            }
        }
    }
}

