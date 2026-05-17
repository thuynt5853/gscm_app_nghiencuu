<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" 
CodeBehind="DanhsachHS.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.VuAn.DanhsachHS" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <style type="text/css">
        .DonGDTCol1 {
            width: 100px;
        }

        .DonGDTCol2 {
            width: 240px;
        }

        .DonGDTCol3 {
            width: 80px;
        }

        .DonGDTCol4 {
            width: 160px;
        }

        .DonGDTCol5 {
            width: 70px;
        }
    </style>
        <asp:HiddenField ID="hddLoaiTK" runat="server" value=""/>
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm
                                    <asp:LinkButton ID="lbtTTTK" runat="server" Text="[ Nâng cao ]" ForeColor="#0E7EEE" OnClick="lbtTTTK_Click"></asp:LinkButton></h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">

                                        <tr>
                                            <td class="DonGDTCol1">Tòa ra BA/QĐ</td>
                                            <td class="DonGDTCol2">
                                                <asp:DropDownList ID="ddlToaXetXu" CssClass="chosen-select"
                                                    runat="server" Width="230px">
                                                </asp:DropDownList>
                                            </td>
                                            <td class="DonGDTCol3">Số BA/QĐ</td>
                                            <td class="DonGDTCol4">
                                                <asp:TextBox ID="txtSoQDBA" runat="server" CssClass="user" Width="152px" MaxLength="50"></asp:TextBox>
                                            </td>
                                            <td class="DonGDTCol5">Ngày BA/QĐ</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <asp:Label ID="lblTitleBC" runat="server" Text="Nguyên đơn"></asp:Label></td>
                                            <td>
                                                <asp:TextBox ID="txtNguyendon" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox></td>
                                            <td>
                                                <asp:Label ID="lblTitleBD" runat="server" Text="Bị đơn"></asp:Label></td>
                                            <td>
                                                <asp:TextBox ID="txtBidon" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                            </td>
                                            <td>Loại án</td>
                                            <td>
                                                <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiAn_SelectedIndexChanged"
                                                    runat="server" Width="160px">
                                                </asp:DropDownList>
                                            </td>
                                        </tr>

                                        <asp:Panel ID="pnTTTK" runat="server" Visible="false">
                                            <tr>
                                                 <td>Trạng thái hồ sơ</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlMuonHoso" runat="server"
                                                         AutoPostBack="true" OnSelectedIndexChanged="ddlMuonHoso_SelectedIndexChanged"
                                                       Width="230px" CssClass="chosen-select">
                                                        <asp:ListItem Value="2" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="Đã có hồ sơ"></asp:ListItem>
                                                        <asp:ListItem Value="0" Text="Chưa có hồ sơ"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="...Đã có phiếu mượn"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="...Chưa có phiếu mượn"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                                <td>Từ ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtTuNgay" runat="server" 
                                                        CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                                <td>Đến ngày</td>
                                                <td>
                                                    <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                    <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                    <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                </td>
                                               </tr>
                                            <tr>
                                                <td>Số phiếu</td>
                                                <td>
                                                   <asp:TextBox ID="txtSophieunhan" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox></td>
                                                <td>Cán bộ giải quyết đơn
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlThamtravien" CssClass="chosen-select"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlThamtravien_SelectedIndexChanged"
                                                        runat="server" Width="160px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td>LĐ phụ trách</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlPhoVuTruong" 
                                                         AutoPostBack="true" OnSelectedIndexChanged="ddlPhoVuTruong_SelectedIndexChanged"
                                                        CssClass="chosen-select"  runat="server" Width="160px">
                                                    </asp:DropDownList></td>
                                                
                                            </tr>
                                            <tr>                                              
                                               
                                                   <td>Số thụ lý</td>
                                                <td>
                                                    <asp:TextBox ID="txtThuly_So" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox></td>
                                          
                                                  <td>Kết quả thụ lý</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlKetquaThuLy" CssClass="chosen-select"
                                                        AutoPostBack="true" OnSelectedIndexChanged="ddlKetquaThuLy_SelectedIndexChanged"
                                                        runat="server" Width="160px">
                                                        <asp:ListItem Value="3" Text="--Tất cả--"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="Chưa có kết quả"></asp:ListItem>
                                                        <asp:ListItem Value="5" Text="Đã có kết quả"></asp:ListItem>
                                                       <%-- <asp:ListItem Value="0" Text="...Trả lời đơn"></asp:ListItem>
                                                        <asp:ListItem Value="1" Text="...Kháng nghị"></asp:ListItem>
                                                        <asp:ListItem Value="2" Text="...Xếp đơn"></asp:ListItem>--%>
                                                    </asp:DropDownList></td>
                                                 <td>Thẩm phán</td>
                                                 <td>
                                                    <asp:DropDownList ID="ddlThamphan"
                                                         AutoPostBack="true" OnSelectedIndexChanged="ddlThamphan_SelectedIndexChanged"
                                                        CssClass="chosen-select" runat="server" Width="160px">
                                                    </asp:DropDownList></td>
                                            </tr>
                                            <tr>
                                               <td>Loại phiếu/CV</td>
                                                 <td colspan ="5">
                                                <asp:DropDownList ID="ddlLoaiphieu"
                                                    AutoPostBack="true" OnSelectedIndexChanged="ddlLoaiphieu_SelectedIndexChanged"
                                                    CssClass="chosen-select" runat="server" Width="230px">
                                                    <asp:ListItem Value="" Text="Tất cả" Selected="True"></asp:ListItem>
                                                    <asp:ListItem Value="0" Text="Phiếu mượn"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Phiếu trả"></asp:ListItem>
                                                    <asp:ListItem Value="2" Text="Phiếu chuyển"></asp:ListItem>
                                                    <asp:ListItem Value="3" Text="Nhận hồ sơ"></asp:ListItem>
                                                    <asp:ListItem Value="4" Text="Công văn XM,BS"></asp:ListItem>
                                                    <asp:ListItem Value="5" Text="Công văn khác"></asp:ListItem>
                                                </asp:DropDownList>

                                                 </td>
                                            </tr>
                                        </asp:Panel>
                                        <tr>
                                            <td></td>
                                            <td align="left" colspan="3">
                                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                            </td>

                                            <td align="right" colspan="2">
                                               <%-- <asp:Button ID="btnThemmoi" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThemmoi_Click" />--%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td colspan="5"></td>
                                        </tr>
                                        <tr>
                                            <td colspan="6">
                                                <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>
               <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">In báo cáo
                                    <asp:LinkButton ID="lkInBC_OpenForm" runat="server" Text="[ Mở ]"
                                        ForeColor="#0E7EEE" OnClick="lkInBC_OpenForm_Click"></asp:LinkButton></h4>
                                <div class="boder" style="padding: 10px;">
                                    <asp:Panel ID="pnInBC" runat="server" Visible="false">
                                        <table class="table1">
                                            <tr>
                                                <td class="DonGDTCol1">Tiêu đề báo cáo</td>
                                                <td>
                                                    <asp:TextBox ID="txtTieuDeBC" runat="server"
                                                        CssClass="user" Width="486px" MaxLength="250" Text="Danh sách các vụ án"></asp:TextBox>   <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput"
                                                        Text="In biểu mẫu" OnClick="cmdPrint_Click" /></td>
                                            </tr>
                                            <tr style="display:none;">
                                                <td>Mẫu báo cáo</td>
                                                <td>
                                                    <asp:DropDownList ID="dropMauBC" CssClass="chosen-select" runat="server" Width="494px">
                                                        <%--<asp:ListItem Value="1" Text="Mẫu 1: Thống kê vụ án chưa có hồ sơ"></asp:ListItem>--%>
                                                        <asp:ListItem Value="2" Text="Mẫu 2: Thống kê vụ án đã có hồ sơ"></asp:ListItem>
                                                        <%--<asp:ListItem Value="3" Text="Mẫu 3: Thống kê vụ án chưa/có tờ trình lãnh đạo vụ"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="Mẫu 4: Thống kê vụ án đang trong giai đoạn giải quyết tờ trình"></asp:ListItem>
                                                        <asp:ListItem Value="5" Text="Mẫu 5: Danh sách án Quốc Hội"></asp:ListItem>--%>
                                                    </asp:DropDownList>
                                                 
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                                </div>
                            </div>
                        </td>
                    </tr>
                 <tr>
                        <td colspan="2">    <asp:Button ID="cmdPrintPhieuMuon" runat="server" CssClass="buttoninput"
                                        Visible="false"
                                        Text="Tạo phiếu" OnClick="cmdPrintPhieuMuon_Click" /></td></tr>
                    <tr>
                        <td colspan="2">
                            <div class="phantrang">
                                <div class="sobanghi">
                                
                                    <asp:Literal ID="lstSobanghiT" runat="server" ></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" Visible="false"
                                        AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Mượn HS</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:HiddenField ID="hddVuAnID" runat="server" Value='<%#Eval("ID")%>' />
                                            <asp:CheckBox ID="chkMuon" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số & Ngày thụ lý</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#(Eval("LisThuLyDon")+"").Replace(";", ", <br/>")%>
                                            <!----------------------------------------->
                                             <%-- CheckHS: <%#Eval("CheckHoSo")%>--%>
                                            <br style="margin-top: 10px;" />
                                            <asp:LinkButton ID="cmdSoDonTrung" runat="server" 
                                                ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Số đơn " + Eval("TONGDON")  + "<br/> (" + Eval("cThulymoi")+ " đơn TLM)"%>'
                                                CommandArgument='<%#Eval("ID") %>' CommandName="SoDonTrung" ></asp:LinkButton>
                                            <br style="margin-top: 10px;" />
                                            <asp:LinkButton ID="cmdCV81" runat="server" Font-Size="12px"
                                                ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Án Quốc hội"%>'
                                                CommandArgument='<%#Eval("ID") %>' CommandName="CongVan81"
                                                Visible='<%# (Eval("IsAnQuocHoi")+"")=="0"?false:true  %>' ></asp:LinkButton>
                                             <br style="margin-top: 10px;" />
                                            <asp:LinkButton ID="cmdChidao" runat="server" Font-Size="12px" 
                                                ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Án chỉ đạo"  %>'
                                                CommandArgument='<%#Eval("arrCHIDAOID") %>' CommandName="CHIDAO"
                                                Visible='<%# (Eval("arrCHIDAOID")+"")==""?false:true  %>'></asp:LinkButton>                                            
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn  ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                        <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("InforBA")%>
                                            <%--<b><%#Eval("SOANPHUCTHAM")%></b>
                                            <br />
                                            <%#Eval("NGAYXUPHUCTHAM")%>
                                            <br />
                                            <span class='line_space'><%#Eval("TOAXX_VietTat")%></span>--%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>   <asp:BoundColumn DataField="NGUYENDON" HeaderText="Nguyên đơn/ Người khởi kiện" HeaderStyle-Width="100px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="BIDON" HeaderText="Bị đơn/ Người bị kiện" HeaderStyle-Width="100px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="QHPLDN" HeaderText="Quan hệ pháp luật" HeaderStyle-Width="150px"></asp:BoundColumn>
                                <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Trạng thái</HeaderTemplate>
                                        <ItemTemplate>
                                            <b><asp:Literal ID="lttLanTT" runat="server"  Visible ="false"></asp:Literal></b>
                                            <br />
                                            <asp:Literal ID="lttDetaiTinhTrang" runat="server"  Visible ="false"></asp:Literal>
                                             <asp:Literal ID="lttKQGQ" runat="server"  Visible ="false"></asp:Literal>
                                               <asp:Literal ID="lttOther" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>                                            
                                               <asp:LinkButton ID="cmdQLHoSo" runat="server" Font-Bold="true" ForeColor="#0e7eee" 
                                                   CommandArgument='<%#Eval("ID") %>' CommandName="QLHS" Text="Quản lý hồ sơ"></asp:LinkButton>
                                         </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                                 <asp:DataGrid ID="gridHS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="35px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Mượn HS</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:HiddenField ID="hddVuAnID" runat="server" Value='<%#Eval("ID")%>' />
                                            <asp:CheckBox ID="chkMuon" runat="server" />
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số & Ngày thụ lý</HeaderTemplate>
                                        <ItemTemplate>
                                             <%#(Eval("LisThuLyDon")+"").Replace(";", ", <br/>")%>
                                            <!----------------------------------------->
                                             <%-- CheckHS: <%#Eval("CheckHoSo")%>--%>
                                            <br style="margin-top: 10px;" />
                                            <asp:LinkButton ID="cmdSoDonTrung" runat="server" 
                                                ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Số đơn " + Eval("TONGDON")  + "<br/> (" + Eval("cThulymoi")+ " đơn TLM)"%>'
                                                CommandArgument='<%#Eval("ID") %>' CommandName="SoDonTrung" ></asp:LinkButton>
                                            <br style="margin-top: 10px;" />
                                            <asp:LinkButton ID="cmdCV81" runat="server" Font-Size="12px"
                                                ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Án Quốc hội"%>'
                                                CommandArgument='<%#Eval("ID") %>' CommandName="CongVan81"
                                                Visible='<%# (Eval("IsAnQuocHoi")+"")=="0"?false:true  %>' ></asp:LinkButton>
                                             <br style="margin-top: 10px;" />
                                            <asp:LinkButton ID="cmdChidao" runat="server" Font-Size="12px" 
                                                ForeColor="#0e7eee" Font-Bold="true" Text='<%# "Án chỉ đạo"  %>'
                                                CommandArgument='<%#Eval("arrCHIDAOID") %>' CommandName="CHIDAO"
                                                Visible='<%# (Eval("arrCHIDAOID")+"")==""?false:true  %>'></asp:LinkButton>                                            
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn  ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                        <HeaderTemplate>Thông tin bản án</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("InforBA")%>
                                           <%-- <b><%#Eval("SOANPHUCTHAM")%></b>
                                            <br />
                                            <%#Eval("NGAYXUPHUCTHAM")%>
                                            <br />
                                            <span class='line_space'><%#Eval("TOAXX_VietTat")%></span>--%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>   
                                     <asp:BoundColumn DataField="QHPLDN" HeaderText="Tội danh" HeaderStyle-Width="120px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUYENDON" HeaderText="Bị cáo đầu vụ" HeaderStyle-Width="70px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="BIDON" HeaderText="Bị cáo khiếu nại" HeaderStyle-Width="70px"></asp:BoundColumn>
                                    <asp:BoundColumn DataField="NGUOIKHIEUNAI" HeaderText="Người khiếu nại" HeaderStyle-Width="90px"></asp:BoundColumn>
                                    <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Trạng thái</HeaderTemplate>
                                        <ItemTemplate>
                                            <b><asp:Literal ID="lttLanTT" runat="server" Visible ="false"></asp:Literal></b>
                                            <br />
                                            <asp:Literal ID="lttDetaiTinhTrang" runat="server"  Visible ="false"></asp:Literal>
                                             <asp:Literal ID="lttKQGQ" runat="server"  Visible ="false"></asp:Literal>
                                               <asp:Literal ID="lttOther" runat="server"></asp:Literal>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="90px" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thao tác</HeaderTemplate>
                                        <ItemTemplate>                                            
                                               <asp:LinkButton ID="cmdQLHoSo" runat="server" Font-Bold="true" ForeColor="#0e7eee" 
                                                   CommandArgument='<%#Eval("ID") %>' CommandName="QLHS" Text="Quản lý hồ sơ"></asp:LinkButton>
                                         </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                </Columns>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back" Visible="false"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="ddlPageCount2" runat="server" Width="55px" CssClass="so" Visible="false" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount2_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        function PopupReport(pageURL, title, w, h) {
            var left = (screen.width / 2) - (w / 2);
            var top = (screen.height / 2) - (h / 2);
            var targetWin = window.open(pageURL, title, 'toolbar=no, channelmode=no,location =no,scrollbars=yes,resizable=no,menubar=no,width=' + w + ', height=' + h + ', top=' + top + ', left=' + left);
            return targetWin;
        }
        function LoadDsDon() {
            $("#<%= cmdTimkiem.ClientID %>").click();
        }
        
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>

</asp:Content>
