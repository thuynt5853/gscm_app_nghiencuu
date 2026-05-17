<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/User.Master" AutoEventWireup="true" CodeBehind="ChiTietDon.aspx.cs" Inherits="WEB.DONKHOIKIEN.Personnal.ChiTietDon" %>

<%@ Register Src="~/Personnal/UC/DonKK_File.ascx" TagPrefix="uc1" TagName="DonKK_File" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <style>
        .table1 tr, td {
            padding-left: 0px;
            padding-bottom: 10px;
        }

        .boxchung {
            margin-bottom: 10px;
        }

        .float_left {
            float: left;
        }
    </style>
    <div class="right_full_width distance_bottom">
        <div class="thongtin_lienhe">
            <div class="right_full_width_head">
                <a href="javascript:;" class="dowload_head">Thông tin đơn khởi kiện</a>
                <div class="dangky_head_right">
                    <div class="tooltip">
                        <a href="/Personnal/DsDon.aspx">
                            <img src="../UI/img/top_back.png" style="width: 28px; float: right;" />
                        </a>
                        <span class="tooltiptext  tooltip-bottom">Quay lại</span>
                    </div>

                </div>
            </div>
            <div class="content_right">
               
                    <!------------------------------------------->
                    <div class="right_full_width head_title_center">
                        <span>Cộng hòa xã hội chủ nghĩa Việt nam</span>
                    </div>
                    <div class="right_full_width head_title_center" style="margin-bottom: 15px;">
                        <span style="text-transform: none;">Độc lập - Tự do - Hạnh phúc</span>
                        <span style="border-bottom:solid 1px gray;width:24%;float:left;margin-left:38%;margin-top:5px;"></span>
                    </div>
                    <!------------------------------>
                <div class="right_full_width align_center" style="margin-bottom: 5px;">
                    <span>Ngày 
                        <asp:Literal ID="lttNgay" runat="server"></asp:Literal>
                        tháng  
                        <asp:Literal ID="lttThang" runat="server"></asp:Literal>
                        năm  
                        <asp:Literal ID="lttNam" runat="server"></asp:Literal></span>
                </div>
                <div class="right_full_width head_title_center">
                    <span style="font-size: 15pt;">Đơn khởi kiện</span>
                </div>

                <!----------------NOI DUNG DON----------------->
                <div class="title_toaan">
                    <span>Kính gửi: </span>
                    <asp:Literal ID="lttToaAn" runat="server"></asp:Literal>
                </div>
                <div class="right_full_width">
                    <!------------Nguyen don--------->
                    <asp:Panel ID="pnNguyenDon" runat="server">
                        <div class="boxchung" style="margin-top: 0px;">
                            <h4 class="tleboxchung">
                                <asp:Literal ID="lstTitleNguyendon" runat="server" Text="Thông tin người khởi kiện"></asp:Literal>
                            </h4>
                            <div class="boder" style="padding: 10px;">
                                <asp:Literal ID="lttcount_ND" runat="server"></asp:Literal>
                                <asp:Repeater ID="rptNguyenDon" runat="server">
                                    <HeaderTemplate>
                                        <table class="table1" cellpadding="5px">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td><b><%# Container.ItemIndex + 1 %>. <%# (Convert.ToInt16(Eval("LoaiDuongSu")+"")==1)? "Họ và tên:":"Cơ quan/Tổ chức:"%></b>
                                                <%#Eval("TenDuongSu") %></td>

                                            <td><%# (Convert.ToInt16(Eval("LoaiDuongSu")+"")==1)? 
                                                        (Convert.ToInt32(Eval("NamSinh")+"")>0? 
                                                        "<b>Ngày sinh:</b>"+ Eval("NamSinh"):"") :"<b>Người đại diện:</b>"+Eval("NguoiDaiDien")  %></td>
                                            <td style="width: 25%;">
                                                <%# (Convert.ToInt16(Eval("LoaiDuongSu")+"")==1)? ("<b>Giới tính:</b>"+ Eval("GioiTinh")) :"<b>Chức vụ:</b>"+Eval("ChucVu") %></td>

                                        </tr>
                                        <tr>
                                            <td><b>Quốc tịch: </b><%#Eval("QuocTich") %></td>
                                            <td><b>Điện thoại/Fax:</b> <%#Eval("DienThoai_Fax") %></td>
                                            <td><b>Số CMND:</b> <%#Eval("SoCMND") %></td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <%# (Convert.ToInt16(Eval("LoaiDuongSu")+"")==1)? "<b>Nơi cư trú hiện tại:</b>": "<b>Địa chỉ:</b>" %>
                                                <%#Eval("HoKhauTamTru")%></td>
                                        </tr>
                                    </ItemTemplate>
                                    <SeparatorTemplate>
                                        <tr>
                                            <td colspan="3" style="border-top: solid 1px #dcdcdc; padding-bottom: 3px;"></td>
                                        </tr>
                                    </SeparatorTemplate>
                                    <FooterTemplate></table></FooterTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </asp:Panel>
                    <!---------Bi don ---------------->
                    <asp:Panel ID="pnBiDon" runat="server">
                        <div class="boxchung" style="margin-top: 0px;">
                            <h4 class="tleboxchung">
                                <asp:Literal ID="Literal1" runat="server" Text="Thông tin người bị kiện"></asp:Literal>
                            </h4>
                            <div class="boder" style="padding: 10px;">
                                <asp:Literal ID="lttcount_BD" runat="server"></asp:Literal>
                                <asp:Repeater ID="rptBiDon" runat="server">
                                    <HeaderTemplate>
                                        <table class="table1">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td><b><%# Container.ItemIndex + 1 %>. <%# (Convert.ToInt16(Eval("LoaiDuongSu")+"")==1)? "Họ và tên:":"Cơ quan/Tổ chức:"%></b>
                                                <%#Eval("TenDuongSu") %></td>
                                            <td><%# (Convert.ToInt16(Eval("LoaiDuongSu")+"")==1)? 
                                                        (Convert.ToInt32(Eval("NamSinh")+"")>0? 
                                                        "<b>Ngày sinh:</b>"+ Eval("NamSinh"):"") :"<b>Người đại diện:</b>"+Eval("NguoiDaiDien")  %></td>
                                            <td style="width: 25%;">
                                                <%# (Convert.ToInt16(Eval("LoaiDuongSu")+"")==1)? ("<b>Giới tính:</b>"+ Eval("GioiTinh")) :"<b>Chức vụ:</b>"+Eval("ChucVu") %></td>
                                        </tr>
                                        <tr>
                                            <td><b>Quốc tịch: </b><%#Eval("QuocTich") %></td>
                                            <td><b>Điện thoại/Fax:</b> <%#Eval("DienThoai_Fax") %></td>
                                            <td><b>Số CMND:</b> <%#Eval("SoCMND") %></td>
                                        </tr>
                                        <tr>
                                            <td colspan="3">
                                                <%# (Convert.ToInt16(Eval("LoaiDuongSu")+"")==1)? "<b>Nơi cư trú hiện tại:</b>": "<b>Địa chỉ:</b>" %><%#Eval("HoKhauTamTru")%>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <SeparatorTemplate>
                                        <tr>
                                            <td colspan="3" style="border-top: solid 1px #dcdcdc; padding-bottom: 3px;"></td>
                                        </tr>
                                    </SeparatorTemplate>
                                    <FooterTemplate></table></FooterTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </asp:Panel>

                    <!----------Duong su--------------->
                    <asp:Panel ID="pnDuongSu" runat="server">
                        <div class="boxchung" style="margin-top: 0px;">
                            <h4 class="tleboxchung">
                                <asp:Literal ID="Literal3" runat="server" Text="Người có quyền, lợi ích được bảo vệ/Người có quyền lợi, nghĩa vụ liên quan/Người làm chứng"></asp:Literal>
                            </h4>
                            <div class="boder" style="padding: 10px;">
                                <asp:Repeater ID="rptDuongSuKhac" runat="server">
                                    <HeaderTemplate>
                                        <div class="CSSTableGenerator" style="float: none; margin-top: 5px;">
                                            <table>
                                                <tr id="row_header">
                                                    <td style="width: 20px;">TT</td>
                                                    <td>Tên</td>
                                                    <td style="width: 60px;">Năm sinh</td>
                                                    <td style="width: 175px;">Tư cách tố tụng</td>
                                                    <td>Địa chỉ hiện tại</td>
                                                </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Container.ItemIndex + 1 %></td>
                                            <td>
                                                <div style="text-align: justify; float: left;">
                                                    <%#Eval("TENDUONGSU") %>
                                                </div>
                                            </td>
                                            <td><%#Convert.ToInt32(Eval("NamSinh")+"")>0? Eval("NamSinh"):"" %></td>
                                            <td><%#Eval("TuCachToTung") %></td>
                                            <td><%#Eval("HoKhauTamTru") %></td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate></table></div></FooterTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </asp:Panel>

                    <!---------Vu viec---------------->
                    <div class="boxchung" style="margin-top: 0px;">
                        <div class="boder" style="padding: 10px; line-height: 22px; margin-top: 0px;">
                            <table class="table1" style="width: 99%;">

                                <asp:Panel ID="pnQDHanhChinh" runat="server">
                                    <tr>
                                        <td colspan="4">
                                            <div style="float: left; width: 98%; margin-bottom: 8px;">
                                                <asp:Literal ID="lttQDHanhChinh" runat="server"></asp:Literal>
                                            </div>
                                        </td>
                                    </tr>
                                </asp:Panel>
                                <tr>
                                    <td colspan="4"><b>Yêu cầu tòa án giải quyết những vấn đề:</b></td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <div style="line-height: 22px">
                                            <asp:Label ID="lblNoidungdon" runat="server"></asp:Label>
                                        </div>
                                    </td>
                                </tr>

                                <tr id="row_QHPL" runat="server">
                                    <td colspan="4"><b>Quan hệ pháp luật:</b><asp:Label ID="lblQuanHePL" runat="server"></asp:Label></td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <!----------tai lieu------------->
                    <asp:Panel ID="pnTaiLieu" runat="server">
                        <asp:Repeater ID="rptFile" runat="server" OnItemCommand="rptFile_ItemCommand">
                            <HeaderTemplate>
                                <div class="boxchung" style="margin-top: 0px;">
                                    <h4 class="tleboxchung">
                                        <asp:Literal ID="Literal4" runat="server" Text="Tài liệu, chứng cứ kèm theo đơn khởi kiện "></asp:Literal>
                                    </h4>
                                    <div class="boder" style="padding: 10px;">
                                        <div class="CSSTableGenerator" style="float: none; margin-top: 5px;">
                                            <table>
                                                <tr id="row_header">
                                                    <td style="width: 20px;">TT</td>
                                                    <td>Tên tài liệu</td>
                                                    <td style="width: 70px;">Tải file</td>
                                                </tr>
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr>
                                    <td><%# Container.ItemIndex + 1 %>
                                        <asp:HiddenField ID="hddTaiLieuID" runat="server"
                                            Value=' <%#Eval("ID") %>' />
                                    </td>
                                    <td>
                                        <div style="text-align: justify; float: left;">
                                            <%#Eval("TenTaiLieu") %>
                                        </div>
                                    </td>

                                    <td>
                                        <div style="text-align: center;">
                                            <asp:ImageButton ID="cmdSua" ImageUrl="/UI/img/dowload.png"
                                                runat="server" ToolTip="Tải file xuống" Width="20px" CommandArgument='<%#Eval("ID").ToString() %>'
                                                CommandName="dowload"></asp:ImageButton>
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                </table></div></div></div>
                            </FooterTemplate>
                        </asp:Repeater>
                    </asp:Panel>

                    <!---------Thong tin thu ly---------------->
                    <asp:Panel ID="pnThuLy" runat="server">

                        <div class="boxchung" style="margin-top: 0px;">
                            <h4 class="tleboxchung">
                                <asp:Literal ID="Literal5" runat="server" Text="Thông tin thụ lý vụ việc"></asp:Literal>
                            </h4>
                            <div class="boder" style="padding: 10px; ">

                                <asp:Repeater ID="rptThuLy" runat="server">
                                    <HeaderTemplate>
                                        <table class="table1">
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td style="width:55%;"><b><%# Eval("STT") %>. Số thụ lý: </b><%#Eval("SoThuLy") %></td>
                                            <td><b>Ngày thụ lý: </b><%# string.Format("{0:dd/MM/yyyy hh:mm tt}",Eval("NgayThuLy")) %></td>
                                        </tr>
                                        <tr>
                                            <td><b>Tòa án thụ lý: </b><%#Eval("TenToaAn") %></td>
                                            <td><b>Trường hợp thụ lý: </b><%#Eval("TruongHopThuLy") %></td>
                                        </tr>
                                        <tr>
                                            <td style="vertical-align:top;" colspan="2"><b>Quan hệ pháp luật: </b> <%#Eval("TenQHPL") %></td>
                                        </tr>
                                    </ItemTemplate>
                                    <SeparatorTemplate>
                                        <tr>
                                            <td colspan="2" style="border-top: solid 1px #dcdcdc; padding-bottom: 3px;"></td>
                                        </tr>
                                    </SeparatorTemplate>
                                    <FooterTemplate></table></FooterTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                    </asp:Panel>
                    <!----------------------->
                    <asp:Panel ID="pnListVBTongDat" runat="server">
                        <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
                        <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
                        <div class="boxchung" style="margin-top: 0px;">
                            <h4 class="tleboxchung">
                                <asp:Literal ID="Literal4" runat="server" Text="Văn bản/ Thông báo từ Tòa án"></asp:Literal>
                            </h4>
                            <div class="boder" style="padding: 10px; float: left;">
                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>

                                <asp:Repeater ID="rptVB" runat="server"
                                    OnItemCommand="rptVB_ItemCommand"
                                    OnItemDataBound="rptVB_ItemDataBound">
                                    <HeaderTemplate>
                                        <div class="CSSTableGenerator">
                                            <table>
                                                <tr id="row_header">
                                                    <td style="width: 20px;">TT</td>
                                                    <td>Văn bản</td>
                                                    <td>Ngày gửi</td>
                                                    <td style="width: 100px;">Trạng thái</td>
                                                    <td style="width: 60px;">Tệp đính kèm</td>
                                                </tr>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr>
                                            <td><%#Eval("STT") %></td>
                                            <td>
                                                <asp:LinkButton ID="lkVB" runat="server" Text='<%#Eval("TenVanBan") %>'
                                                    CommandArgument='<%#Eval("VanBanID") %>' CommandName="view"></asp:LinkButton>
                                            </td>
                                            <td><%# string.Format("{0:dd/MM/yyyy}",Eval("NgayGui")) %>
                                            </td>

                                            <td>-Trạng thái : <%#Eval("TrangThaiDoc") %><br />
                                                <%#(string.IsNullOrEmpty(Eval("NgayDoc")+""))? "": "-Ngày tiếp nhận: "+string.Format("{0:dd/MM/yyyy hh:mm tt}",Eval("NgayDoc")) %>
                
                                            </td>
                                            <td>
                                                <div class="align_center">
                                                    <asp:ImageButton ID="imgFile" runat="server"
                                                        CommandArgument='<%#Eval("VanBanID") %>' CommandName="dowload" />
                                                </div>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        </table>
</div>
                                    </FooterTemplate>
                                </asp:Repeater>

                                <div class="phantrang">
                                    <div class="sobanghi">
                                        <asp:HiddenField ID="hdicha" runat="server" />
                                        <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                    </div>
                                    <div class="sotrang">
                                        <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                            OnClick="lbTBack_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                            Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                            Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                            Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                            Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                            Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                        <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                                        <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                            Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                        <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                            OnClick="lbTNext_Click"></asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:Panel>

                    <asp:Literal ID="lttThongTinThem" runat="server"></asp:Literal>
                </div>
                <!--------------------------------------------->

                <div class="fullwidth" style="text-align: center;">
                    <asp:Literal runat="server" ID="lbthongbao"></asp:Literal><br />
                    <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput print"
                        Text="In đơn" OnClientClick="show_popup_in()" />
                    <asp:Button ID="cmdBack" runat="server" CssClass="buttoninput quaylai"
                        Text="Quay lại" OnClick="cmdBack_Click" />
                </div>
            </div>
        </div>
    </div>
    <script>
        function show_popup_in() {
            var donkhoikienID = '<%=DonKKID%>';
            var para = "";
            var pageURL = "/Personnal/InBC.aspx";


            if (donkhoikienID > 0)
                para += "?dkkID=" + donkhoikienID;
            pageURL += para;

            var page_width = 880;
            var page_height = 550;
            var left = (screen.width / 2) - (page_width / 2);
            var top = (screen.height / 2) - (page_height / 2);
            var targetWin = window.open(pageURL, 'In đơn khởi kiện'
                , 'toolbar=no,scrollbars=yes,resizable=no'
                + ', width = ' + page_width
                + ', height=' + page_height + ', top=' + top + ', left=' + left);
            return targetWin;
        }
    </script>
</asp:Content>
