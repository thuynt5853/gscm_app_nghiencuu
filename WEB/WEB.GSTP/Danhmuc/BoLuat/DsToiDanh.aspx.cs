using DAL.GSTP;
using BL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Data;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System.Web.UI.WebControls;
using DevExpress.Utils.Extensions;
using BL.GSTP.BANGSETGET.DANHMUC;
using BL.GSTP.BANGSETGET;

namespace WEB.GSTP.Danhmuc.BoLuat
{
    public partial class DsToiDanh : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public int TYPE = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadDropBoLuat();
                    try
                    {
                        if (Request["bID"] != null)
                            dropBoLuat.SelectedValue = Request["bID"].ToString();
                        LoadDrop_ToiDanh_ByParentID(0, dropChuong, 1);

                        dropDieu.Items.Add(new ListItem("---Chọn---", "0"));
                        dropKhoan.Items.Add(new ListItem("---Chọn---", "0"));


                        if (Request["chuongID"] != null)
                            dropChuong.SelectedValue = Request["chuongID"].ToString();
                        if (Request["dieuID"] != null)
                        {
                            LoadDrop_ToiDanh_ByParentID(Convert.ToDecimal(dropChuong.SelectedValue), dropDieu, 2);
                            dropDieu.SelectedValue = Request["dieuID"].ToString();
                        }
                        if (Request["khoanID"] != null)
                        {
                            LoadDrop_ToiDanh_ByParentID(Convert.ToDecimal(dropDieu.SelectedValue), dropKhoan, 3);
                            dropKhoan.SelectedValue = Request["khoanID"].ToString();
                        }
                    }
                    catch (Exception ex) { }

                    //---------------------------
                    hddPageIndex.Value = "1";
                    LoadGrid();

                    //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    //Cls_Comon.SetButton(cmdTh, oPer.CAPNHAT);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        void LoadDropBoLuat()
        {
            dropBoLuat.Items.Clear();
            // dropBoLuat.Items.Add(new ListItem("---Chọn---", "0"));
            List<DM_BOLUAT> lst = dt.DM_BOLUAT.Where(x => x.HIEULUC == 1).ToList();
            if (lst != null && lst.Count > 0)
            {
                foreach (DM_BOLUAT item in lst)
                    dropBoLuat.Items.Add(new ListItem(item.TENBOLUAT, item.ID.ToString()));
            }
            dropBoLuat.SelectedValue = "7";
        }
        void LoadDrop_ToiDanh_ByParentID(Decimal ParentID, DropDownList drop, int level)
        {
            Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);

            drop.Items.Clear();
            drop.Items.Add(new ListItem("---Chọn---", "0"));
            List<DM_BOLUAT_TOIDANH> lst = null;
            lst = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == boluatid && x.CAPCHAID == ParentID).OrderBy(y => y.THUTU).ToList();
            if (lst != null)
            {
                String text_display = "";
                foreach (DM_BOLUAT_TOIDANH item in lst)
                {
                    text_display = "";
                    switch (level)
                    {
                        case 1:
                            text_display = "";
                            break;
                        case 2:
                            text_display = item.DIEU + ".";
                            break;
                        case 3:
                            text_display = item.KHOAN + ".";
                            break;
                    }
                    drop.Items.Add(new ListItem(text_display + item.TENTOIDANH, item.ID.ToString()));
                }
            }
        }
        void LoadGrid()
        {
            lbthongbao.Text = "";
            string textsearch = txttimkiem.Text.Trim();
            decimal capcha_id = 0;
            int loai_view = 0;// Convert.ToInt16(rdLoai.SelectedValue);
            //if (!String.IsNullOrEmpty(dropChuong.SelectedValue) && dropChuong.SelectedValue != "0")
            if ( dropChuong.SelectedValue != "0")
            {
                loai_view = 2;
                capcha_id = Convert.ToDecimal(dropChuong.SelectedValue);
            }
            //if (!String.IsNullOrEmpty(dropDieu.SelectedValue) && dropDieu.SelectedValue != "0")
            if ( dropDieu.SelectedValue != "0")
            {
                capcha_id = Convert.ToDecimal(dropDieu.SelectedValue);
                loai_view = 3;
            }
            //if (!String.IsNullOrEmpty(dropKhoan.SelectedValue) && dropKhoan.SelectedValue != "0")
            if (dropKhoan.SelectedValue != "0")
            {
                capcha_id = Convert.ToDecimal(dropKhoan.SelectedValue);
                loai_view = 4;
            }

            int hieuluc = Convert.ToInt32(dropHieuLuc.SelectedValue);
            int pagesize = 20;
            int pageindex = Convert.ToInt32(hddPageIndex.Value);

            int boluatid = Convert.ToInt32(dropBoLuat.SelectedValue);
            // String.IsNullOrEmpty(Request["type"] + "") ? 1 : Convert.ToInt16(Request["type"] + "");

            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            DataTable tbl = null;
            tbl = objBL.SearchDM(boluatid, loai_view, capcha_id, textsearch, hieuluc, pageindex, pagesize);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");

                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, pagesize).ToString();
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
                lbthongbao.Text = "Không tìm thấy dữ liệu phù hợp điều kiện!";
            }
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
                // rpt.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                //  rpt.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
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
                // rpt.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
        protected void cmdThemMoi_Click(object sender, EventArgs e)
        {
            String para = "boluatID=" + dropBoLuat.SelectedValue;
            Response.Redirect("Edit.aspx?" + para);
        }
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);

                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                DataRowView dv = (DataRowView)e.Item.DataItem;
                int LuatID = (string.IsNullOrEmpty(dv["LuatID"] + "")) ? 0 : Convert.ToInt32(dv["LuatID"] + "");
                DM_BOLUAT boLuat = dt.DM_BOLUAT.Where(x => x.ID == LuatID).FirstOrDefault();
                DropDownList dropTOIDANHTK = (DropDownList)e.Item.FindControl("dropTOIDANHTK");
                if (boLuat != null && boLuat.LOAI == "01")
                {
                    int TOIDANHTK_ID = (string.IsNullOrEmpty(dv["TOIDANHTK_ID"] + "")) ? 0 : Convert.ToInt32(dv["TOIDANHTK_ID"] + "");
                    string TenToiDanh = dv["TenToiDanh"]?.ToString();
                    LoadDropTOIDANHTK(dropTOIDANHTK, TOIDANHTK_ID, TenToiDanh);
                    if (TOIDANHTK_ID == 0 && dropTOIDANHTK.SelectedValue != "0")
                    {
                        Literal ltdropTOIDANHTK = (Literal)e.Item.FindControl("ltdropTOIDANHTK");
                        ltdropTOIDANHTK.Text = "<span style='color:red'>(Gợi ý)</span>";
                    }
                }
                else
                {
                    dropTOIDANHTK.Visible = false;
                }



                DropDownList dropTOIDANHCONGBO = (DropDownList)e.Item.FindControl("dropTOIDANHCONGBO");
                if (boLuat != null && boLuat.LOAI == "01")
                {
                    int TOIDANHCONGBO_ID = (string.IsNullOrEmpty(dv["CONGBO_CASE_ID"] + "")) ? 0 : Convert.ToInt32(dv["CONGBO_CASE_ID"] + "");
                    string TenToiDanh = dv["TenToiDanh"]?.ToString();
                    LoadDropTOIDANHCONGBO(dropTOIDANHCONGBO, TOIDANHCONGBO_ID, TenToiDanh);
                    if (TOIDANHCONGBO_ID == 0 && dropTOIDANHCONGBO.SelectedValue != "0")
                    {
                        Literal ltdropTOIDANHCONGBO = (Literal)e.Item.FindControl("ltdropTOIDANHCONGBO");
                        ltdropTOIDANHCONGBO.Text = "<span style='color:red'>(Gợi ý)</span>";
                    }
                }
                else
                {
                    dropTOIDANHCONGBO.Visible = false;
                }
            }
        }
        void LoadDropTOIDANHTK(DropDownList drop, decimal BoLuatId, string TenToiDanh)
        {
            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            DataTable tbl = objBL.GetDanhSachTOIDANHTK();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                if (BoLuatId == 0)
                {
                    TenToiDanh = TenToiDanh.ToLower();
                    foreach (DataRow item in tbl.Rows)
                    {

                        if (item["CRIMINAL_ID"].ToString().ToLower().Contains(TenToiDanh))
                            BoLuatId = Convert.ToDecimal(item["ID"].ToString());
                    }
                }
                drop.Items.Clear();
                drop.DataSource = tbl;
                drop.DataTextField = "CRIMINAL_ID";
                drop.DataValueField = "ID";
                drop.DataBind();
                drop.Items.Insert(0, new ListItem("Chọn", "0"));
                if (BoLuatId > 0)
                {
                    drop.SelectedValue = BoLuatId.ToString();
                }
            }
        }
        void LoadDropTOIDANHCONGBO(DropDownList drop, decimal BoLuatId, string TenToiDanh)
        {
            CONGBO_BL TK_BL = new CONGBO_BL();
            DataTable tbl = TK_BL.DBLINK_GET_LIST_TC_CRIMINALS_LIST_FRONT_END();
            if (tbl != null && tbl.Rows.Count > 0)
            {
                if (BoLuatId == 0)
                {
                    TenToiDanh = TenToiDanh.ToLower();
                    foreach (DataRow item in tbl.Rows)
                    {

                        if (item["CRIMINAL_NAME"].ToString().ToLower().Contains(TenToiDanh))
                            BoLuatId = Convert.ToDecimal(item["ID"].ToString());
                    }
                }
                drop.Items.Clear();
                drop.DataSource = tbl;
                drop.DataTextField = "CRIMINAL_NAME";
                drop.DataValueField = "ID";
                drop.DataBind();
                drop.Items.Insert(0, new ListItem("Chọn", "0"));
                if (BoLuatId > 0)
                {
                    drop.SelectedValue = BoLuatId.ToString();
                }
            }
        }
        protected void rpt_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            lbthongbao.Text = "";
            decimal curr_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "list_child":
                    Response.Redirect("Edit.aspx?type=" + (TYPE + 1)
                                                + "&boluatID=" + dropBoLuat.SelectedValue
                                                + "&pID=" + curr_id);
                    break;
                case "Sua":
                    Response.Redirect("Edit.aspx?cID=" + curr_id);
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    xoa(curr_id);
                    break;
            }
        }
        public void xoa(decimal id)
        {
            List<DM_BOLUAT_TOIDANH_HINHPHAT> lst = dt.DM_BOLUAT_TOIDANH_HINHPHAT.Where(x => x.TOIDANHID == id).ToList();
            if (lst.Count > 0)
            {
                foreach (DM_BOLUAT_TOIDANH_HINHPHAT item in lst)
                    dt.DM_BOLUAT_TOIDANH_HINHPHAT.Remove(item);
            }

            DM_BOLUAT_TOIDANH oT = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == id).FirstOrDefault();
            dt.DM_BOLUAT_TOIDANH.Remove(oT);
            dt.SaveChanges();

            //------------------------------
            //Resetcontrol();

            hddPageIndex.Value = "1";
            LoadGrid();
            lbthongbao.Text = "Xóa thành công!";
        }


        protected void dropBoLuat_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadDrop_ToiDanh_ByParentID(0, dropChuong, 1);

            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void dropChuong_SelectedIndexChanged(object sender, EventArgs e)
        {
            Decimal parentID = Convert.ToDecimal(dropChuong.SelectedValue);
            if (parentID > 0)
            {
                DM_BOLUAT_TOIDANH obj = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == parentID).Single();
                //hddMaChuong.Value = obj.CHUONG;

                LoadDrop_ToiDanh_ByParentID(parentID, dropDieu, 2);
                hddPageIndex.Value = "1";
                LoadGrid();
            }
        }

        protected void dropDieu_SelectedIndexChanged(object sender, EventArgs e)
        {
            Decimal parentID = Convert.ToDecimal(dropDieu.SelectedValue);
            if (parentID > 0)
            {
                DM_BOLUAT_TOIDANH obj = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == parentID).Single();
                //  hddMaDieu.Value = obj.DIEU;
                LoadDrop_ToiDanh_ByParentID(parentID, dropKhoan, 3);

                hddPageIndex.Value = "1";
                LoadGrid();
            }
        }

        protected void dropKhoan_SelectedIndexChanged(object sender, EventArgs e)
        {
            Decimal parentID = Convert.ToDecimal(dropKhoan.SelectedValue);
            if (parentID > 0)
            {
                DM_BOLUAT_TOIDANH obj = dt.DM_BOLUAT_TOIDANH.Where(x => x.ID == parentID).Single();
                //hddMaKhoan.Value = obj.KHOAN;

                hddPageIndex.Value = "1";
                LoadGrid();
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
            int level = 1;
            UpdateTTChild(boluatid, 0, "", level, "");
            lbthongbao.Text = "Update xong!";
        }
        protected void btnUpdateArrSapXep_Click(object sender, EventArgs e)
        {
            Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
            int level = 1;
            UpdateArrSapXep();
            lbthongbao.Text = "Update xong!";
        }
        protected void cmUpdateConfig_Click(object sender, EventArgs e)
        {
            int IsUpdate = 0;
            foreach (RepeaterItem item in rpt.Items)
            {
                HiddenField hddID = (HiddenField)item.FindControl("hddID");
                Decimal ToiDanh_ID = Convert.ToDecimal(hddID.Value);

                DropDownList dropTOIDANHTK = (DropDownList)item.FindControl("dropTOIDANHTK");
                Decimal TOIDANHTK_ID = Convert.ToDecimal(dropTOIDANHTK.SelectedValue);
                String TOIDANHTK_TEN = dropTOIDANHTK.SelectedItem.Text;
                
                DropDownList dropTOIDANHCONGBO = (DropDownList)item.FindControl("dropTOIDANHCONGBO");
                Decimal CONGBO_CASE_ID = Convert.ToDecimal(dropTOIDANHCONGBO.SelectedValue);
                String CONGBO_CASE_NAME = dropTOIDANHTK.SelectedItem.Text;

                HiddenField hddOldTOIDANHTK_ID = (HiddenField)item.FindControl("hddOldTOIDANHTK_ID");
                Decimal Old_TOIDANHTK_ID = 0;
                if (hddOldTOIDANHTK_ID != null && !String.IsNullOrEmpty(hddOldTOIDANHTK_ID.Value))
                    Old_TOIDANHTK_ID = Convert.ToDecimal(hddOldTOIDANHTK_ID.Value);

                decimal check_update = 0;
                if ((TOIDANHTK_ID != Old_TOIDANHTK_ID) || (CONGBO_CASE_ID != Old_TOIDANHTK_ID))
                {
                    DM_BOLUAT_TOIDANH_QHTK obj = DataExtensions.GetAllWithClause<DM_BOLUAT_TOIDANH_QHTK>($"TOIDANH_ID = {ToiDanh_ID}").FirstOrDefault();
                    if (obj == null)
                    {
                        check_update = 0;
                        obj = new DM_BOLUAT_TOIDANH_QHTK();
                    }
                    else
                    {
                        check_update = 1;
                    }

                    obj.TOIDANHTK_ID = TOIDANHTK_ID;
                    obj.TOIDANHTK_TEN = TOIDANHTK_TEN;
                    obj.TOIDANH_ID = ToiDanh_ID;
                    obj.CONGBO_CASE_NAME = CONGBO_CASE_NAME;
                    obj.CONGBO_CASE_ID = CONGBO_CASE_ID; 
 
                    if (check_update > 0)
                        DataExtensions.Update(obj);
                    else
                        DataExtensions.Insert(obj);
                    IsUpdate++;
                }
            }
            //------------------------
            if (IsUpdate > 0)
            {
                LoadGrid();
                lbthongbao.Text = "Cập nhật dữ liệu thành công!";
            }

        }

        #region Update ArrThuTu, ArrSapXep


        void UpdateArrSapXep()
        {
            DM_BOLUAT_TOIDANH obj = null;
            Decimal boluatid = Convert.ToDecimal(dropBoLuat.SelectedValue);
            String SQL = "select ID, LuatID,CapChaID, Loai, ThuTu, chuong, Dieu, Khoan, Diem, ArrThuTu, ArrSapXep, TenToiDanh";
            SQL += " from DM_BoLuat_ToiDanh where LuatID =" + boluatid + " and ArrThuTu is null ";// and cast(chuong as number)>=18";
            SQL += " order by cast(chuong as number), cast(Dieu as Number), cast(Khoan as number), Diem";

            DataTable tbl = Cls_Comon.GetTableToSQL(SQL);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Decimal currid = 0, capchaid = 0;
                int level = 0, thutu = 0; ;
                string ArrSapXep = "", ArrThuTu = "";
                string chuong = "", dieu = "", khoan = "", diem = "";

                foreach (DataRow row in tbl.Rows)
                {
                    currid = Convert.ToDecimal(row["ID"] + "");
                    level = Convert.ToInt16(row["Loai"] + "");
                    chuong = row["Chuong"].ToString();
                    dieu = String.IsNullOrEmpty(row["Dieu"] + "") ? "" : row["Dieu"].ToString();
                    khoan = String.IsNullOrEmpty(row["Khoan"] + "") ? "" : row["Khoan"].ToString();
                    diem = String.IsNullOrEmpty(row["Diem"] + "") ? "" : row["Diem"].ToString();
                    if (level >= 1)
                    {
                        obj = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == boluatid && x.CHUONG == chuong && x.LOAI == 1).FirstOrDefault();
                        if (obj != null)
                        {
                            ArrSapXep = obj.ID.ToString();
                            //ArrThuTu = GetChuoiThuTu(Convert.ToInt32(obj.ARRTHUTU));
                            if (level > 1)
                                capchaid = obj.ID;
                        }
                    }
                    if (level >= 2)
                    {
                        obj = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == boluatid
                        && x.CHUONG == chuong && x.DIEU == dieu && x.LOAI == 2).FirstOrDefault();
                        if (obj != null)
                        {
                            ArrSapXep += "/" + obj.ID.ToString();
                            // ArrThuTu += "/" +(String.IsNullOrEmpty(obj.THUTU))? GetChuoiThuTu(Convert.ToInt32(obj.ARRTHUTU));
                            if (level > 2) capchaid = obj.ID;
                        }
                    }
                    if (level >= 3)
                    {
                        obj = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == boluatid
                            && x.CHUONG == chuong && x.DIEU == dieu && x.KHOAN == khoan && x.LOAI == 3).FirstOrDefault();
                        if (obj != null)
                        {
                            ArrSapXep += "/" + obj.ID.ToString();
                            // ArrThuTu += "/" + GetChuoiThuTu(Convert.ToInt32(obj.ARRTHUTU));
                            if (level > 3) capchaid = obj.ID;
                        }
                    }
                    if (level == 4)
                    {
                        obj = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == boluatid
                            && x.CHUONG == chuong && x.DIEU == dieu && x.KHOAN == khoan && x.DIEM == diem && x.LOAI == 4).Single();
                        if (obj != null)
                            ArrSapXep += "/" + obj.ID.ToString();
                    }
                    obj = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == boluatid && x.ID == currid).Single();

                    //obj.THUTU = intThutu;
                    obj.CAPCHAID = capchaid;
                    obj.ARRSAPXEP = ArrSapXep;
                    // obj.ARRTHUTU = ArrThuTu;
                    dt.SaveChanges();
                }
            }
        }

        void UpdateTTChild(Decimal boluatid, decimal ParentID, String ParentArrThuTu, int level, String ParentArrSapXep)
        {

            List<DM_BOLUAT_TOIDANH> lst = null;
            switch (level)
            {
                case 1:
                    lst = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == boluatid
                                                                    && x.LOAI == level
                                                                    && x.CAPCHAID == ParentID).OrderBy(y => y.TENTOIDANH).ToList();
                    break;
                case 2:
                    lst = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == boluatid
                                                                  && x.LOAI == level
                                                                  && x.CAPCHAID == ParentID).OrderBy(y => y.DIEU).ToList();

                    break;
                case 3:
                    lst = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == boluatid
                                                                  && x.LOAI == level
                                                                  && x.CAPCHAID == ParentID).OrderBy(y => y.KHOAN).ToList();

                    break;
                case 4:
                    lst = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == boluatid
                                                                  && x.LOAI == level
                                                                  && x.CAPCHAID == ParentID).OrderBy(y => y.DIEM).ToList();

                    break;
            }
            if (lst != null && lst.Count > 0)
            {
                int intThutu = 0;

                foreach (DM_BOLUAT_TOIDANH item in lst)
                {
                    switch (level)
                    {
                        case 1://chuong
                            if (item.TENTOIDANH.ToLower().Contains("mục"))
                                intThutu++;
                            else
                                intThutu = Convert.ToInt32(item.CHUONG);
                            item.ARRSAPXEP = item.ID.ToString();
                            break;
                        case 2://dieu
                            try { intThutu = Convert.ToInt32(item.DIEU); } catch (Exception ex) { intThutu++; }
                            item.ARRSAPXEP = ParentArrSapXep + "/" + item.ID.ToString();
                            break;
                        case 3: //khoan
                            try { intThutu = Convert.ToInt32(item.KHOAN); } catch (Exception ex) { intThutu++; }
                            item.ARRSAPXEP = ParentArrSapXep + "/" + item.ID.ToString();
                            break;
                        case 4://diem
                            intThutu++;
                            item.ARRSAPXEP = ParentArrSapXep + "/" + item.ID.ToString();
                            break;
                    }

                    item.THUTU = intThutu;
                    item.ARRTHUTU = ((string.IsNullOrEmpty(ParentArrThuTu)) ? "" : (ParentArrThuTu + "/")) + GetChuoiThuTu(intThutu);

                    dt.SaveChanges();
                    //-----------------
                    if (level < 4)
                        UpdateTTChild((Decimal)item.LUATID, item.ID, item.ARRTHUTU, level + 1, item.ARRSAPXEP);
                }
            }
        }
        string GetChuoiThuTu(int intThutu)
        {
            string temp = "";
            if (intThutu < 10)
                temp = "0000" + intThutu.ToString();
            else if (intThutu < 100)
                temp = "000" + intThutu.ToString();
            else if (intThutu < 1000)
                temp = "00" + intThutu.ToString();
            else if (intThutu < 10000)
                temp = "0" + intThutu.ToString();
            else
                temp += intThutu.ToString();
            return temp;
        }
        #endregion

    }
}

