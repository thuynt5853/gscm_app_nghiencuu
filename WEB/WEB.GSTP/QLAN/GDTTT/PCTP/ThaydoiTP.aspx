<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="ThaydoiTP.aspx.cs" Inherits="WEB.GSTP.QLAN.GDTTT.PCTP.ThaydoiTP" %>
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

        .ajax__calendar_container {
            width: 180px;
        }

        .ajax__calendar_body {
            width: 100%;
            height: 140px;
        }
    </style>
    <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm
                                    </h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td class="DonGDTCol1">Thụ lý đơn từ</td>
                                            <td class="DonGDTCol2">
                                                <asp:TextBox ID="txtThuly_Tu" runat="server" CssClass="user" Width="222px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender8" runat="server" TargetControlID="txtThuly_Tu" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender8" runat="server" TargetControlID="txtThuly_Tu" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td class="DonGDTCol3">Đến ngày</td>
                                            <td class="DonGDTCol4">
                                                <asp:TextBox ID="txtThuly_Den" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender9" runat="server" TargetControlID="txtThuly_Den" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender9" runat="server" TargetControlID="txtThuly_Den" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                            <td class="DonGDTCol5">Số thụ lý</td>
                                            <td>
                                                <asp:TextBox ID="txtThuly_So" runat="server" CssClass="user"
                                                    Width="152px" MaxLength="250"></asp:TextBox></td>
                                        </tr>

                                        <tr>
                                            <td>Tòa ra BA/QĐ</td>
                                            <td>
                                                <asp:DropDownList ID="ddlToaXetXu" CssClass="chosen-select" runat="server" Width="230px"></asp:DropDownList>
                                            </td>
                                            <td>Số BA/QĐ</td>
                                            <td>
                                                <asp:TextBox ID="txtSoQDBA" runat="server" CssClass="user" Width="152px" MaxLength="50"></asp:TextBox>
                                            </td>
                                            <td>Ngày BA/QĐ</td>
                                            <td>
                                                <asp:TextBox ID="txtNgayBAQD" runat="server" CssClass="user" Width="152px" MaxLength="10"></asp:TextBox>
                                                <cc1:CalendarExtender ID="CalendarExtender6" runat="server" TargetControlID="txtNgayBAQD" Format="dd/MM/yyyy" Enabled="true" />
                                                <cc1:MaskedEditExtender ID="MaskedEditExtender6" runat="server" TargetControlID="txtNgayBAQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            </td>
                                        </tr>
                                     
                                            <tr>
                                                 <td><asp:Literal ID="labelNguyenDon" runat="server" Text="Nguyên đơn/ Người khởi kiện"></asp:Literal></td>
                                              
                                                <td>
                                                    <asp:TextBox ID="txtNguyendon" runat="server" CssClass="user" Width="222px" MaxLength="250"></asp:TextBox></td>
                                                   <td><asp:Literal ID="labelBiDon" runat="server" Text="Bị đơn/ Người  bị kiện"></asp:Literal></td>
                                            
                                                <td>
                                                    <asp:TextBox ID="txtBidon" runat="server" CssClass="user" Width="152px" MaxLength="250"></asp:TextBox>
                                                </td>
                                               <td>Thẩm phán</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="160px">
                                                    </asp:DropDownList></td>
                                            </tr>

                                            <tr>
                                                <td>Đơn vị</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlVuGKDT" CssClass="chosen-select" 
                                                         AutoPostBack="true" OnSelectedIndexChanged="ddlVuGKDT_SelectedIndexChanged"
                                                        runat="server" Width="230px">
                                                      <%--  <asp:ListItem Value="2" Text="Vụ GKDT 1"></asp:ListItem>
                                                        <asp:ListItem Value="3" Text="Vụ GKDT 2"></asp:ListItem>
                                                        <asp:ListItem Value="4" Text="Vụ GKDT 3" Selected ="True"></asp:ListItem>--%>
                                                    </asp:DropDownList>
                                                </td>
                                                
                                                 <td>Loại án</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select" runat="server" Width="160px">
                                                    </asp:DropDownList>
                                                </td>
                                                <td></td>
                                                <td>
                                                    </td>
                                               
                                            </tr>
                                        
                                        <tr>
                                            <td>Trạng thái</td>
                                            <td colspan="3">
                                                <asp:RadioButtonList ID="rdbPhancongThamphan" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rdbPhancongThamphan_SelectedIndexChanged">
                                                    <asp:ListItem Value="0" Text="Chưa phân công TP"></asp:ListItem>
                                                    <asp:ListItem Value="1" Text="Đã phân công TP" Selected="True"></asp:ListItem>
                                                </asp:RadioButtonList>
                                            </td>
                                            <td></td>
                                             <td>
                                                    
                                             </td>
                                        </tr>
                                        <tr>
                                            <td></td>
                                            <td colspan="4" align="Center">
                                                <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                                <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                                <asp:Button ID="cmdPrint" runat="server" CssClass="buttoninput"
                                                    Text="In danh sách" OnClick="cmdPrint_Click" />
                                            </td>
                                            <td align="right"></td>
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
                            <div class="phantrang">
                                <div class="sobanghi" style="width: 270px;">
                                    <asp:Button ID="cmdUpdate" ToolTip="Lưu kết quả phân công"
                                        runat="server" CssClass="buttoninput" Text="Lưu phân công"
                                        Height="26px" OnClick="cmdUpdate_Click" />
                                </div>
                                <div class="sotrang" style="width: 45%;">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                    &nbsp;&nbsp;
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
                                    <asp:DropDownList ID="ddlPageCount" runat="server" Width="55px" CssClass="so" Visible="false" AutoPostBack="True" OnSelectedIndexChanged="ddlPageCount_SelectedIndexChanged">
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
                                <AlternatingItemStyle CssClass="le"></AlternatingItemStyle>
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Chọn</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:HiddenField ID="hddCurrID" runat="server" Value='<%#Eval("ID")%>' />
                                            <asp:CheckBox ID="chkChon" runat="server" AutoPostBack="true" ToolTip='<%#Eval("ID")%>' OnCheckedChanged="chkChon_CheckedChanged" />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="30px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số & Ngày thụ lý</HeaderTemplate>
                                        <ItemTemplate>
                                            <%--<%#Eval("SOTHULYDON")%>
                                            <br />
                                            <%#Eval("NGAYTHULYDON")%>--%>
                                             <%#(Eval("LisThuLyDon")+"").Replace(";", ", <br/>")%>

                                            <br style="margin-top: 10px;" />
                                            <asp:LinkButton ID="cmdSoDonTrung" runat="server" ForeColor="#0e7eee" Font-Bold="true"
                                                CommandArgument='<%#Eval("arrDONID") %>' CommandName="SoDonTrung"
                                                Text='<%# "Số đơn " + Eval("TONGDON")  + "<br/> (" + Eval("cThulymoi")+ " đơn TLM)"  %>'></asp:LinkButton>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="60px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Bản án/Quyết định</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("InforBA")%>
                                            <%--<b><%#Eval("SOANPHUCTHAM")%></b>
                                            <br />
                                            <%#Eval("NGAYXUPHUCTHAM")%>
                                            <br />
                                            <span class='line_space'><%#Eval("TOAXX_VietTat")%></span>--%>
                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Center" Width="80px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>

                                    <asp:BoundColumn DataField="NGUYENDON" HeaderText="Nguyên đơn/ Người khởi kiện" HeaderStyle-Width="120px">
                                        <HeaderStyle Width="120px"></HeaderStyle>
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="BIDON" HeaderText="Bị đơn/ Người  bị kiện" HeaderStyle-Width="120px">
                                        <HeaderStyle Width="120px"></HeaderStyle>
                                    </asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="12%" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>
                                            Người đề nghị
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <%#(Eval("NGUOIKHIEUNAI")+"").Replace(",", ",<br/>")%>
                                        </ItemTemplate>
                                    </asp:TemplateColumn>

                                    <%--<asp:BoundColumn DataField="TENTHAMPHAN"  HeaderText="Thẩm phán" HeaderStyle-Width="90px"></asp:BoundColumn>--%>
                                    <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                        <HeaderTemplate>Ngày phân công (HT)</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtNgayPhanCongTP" runat="server" CssClass="user" Width="80px"  
                                                MaxLength="10" placeholder="..../..../....." Text='<%#Eval("NGAYPHANCONGTP") %>'></asp:TextBox>
                                            <cc1:CalendarExtender ID="CE_PCTP" runat="server" TargetControlID="txtNgayPhanCongTP" Format="dd/MM/yyyy" Enabled="true"/>
                                            <cc1:MaskedEditExtender ID="ME__PCTP" runat="server" TargetControlID="txtNgayPhanCongTP" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            <asp:HiddenField ID="hddISVKS_KN" runat="server" Value='<%#Eval("IsVienTruongKN")%>' />
                                            <asp:HiddenField ID="hddNGAYTP" runat="server" Value='<%#Eval("NGAYPHANCONGTP") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="80px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                   
                                    <asp:TemplateColumn HeaderStyle-Width="150px" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thẩm phán</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="lttTP" runat="server" Text='<%#Eval("TenThamPhan") %>'></asp:Literal>
                                            <asp:DropDownList CssClass="chosen-select" ID="dropThamPhan" runat="server" Width="150px"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropThamPhan_SelectedIndexChanged">
                                            </asp:DropDownList>
                                            <asp:HiddenField ID="hddTPID" runat="server" Value='<%#Eval("THAMPHANID") %>' />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="150px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>
                              
                                    <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="150px">
                                        <HeaderTemplate>Lý do thay đổi</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtLyDo" CssClass="user"
                                                runat="server" Width="150px" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Center" Width="150px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                        <HeaderTemplate>Số tờ trình</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtSoTT" runat="server" Text='<%#Eval("CD_SOTOTRINH") %>' CssClass="user" Width="40px" MaxLength="250"></asp:TextBox>
                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Center" Width="50px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                        <HeaderTemplate>Ngày tờ trình</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtNgayToTrinh" runat="server" CssClass="user" Width="70px"  
                                                MaxLength="10" placeholder="..../..../....." Text='<%#Eval("CD_NGAYTOTRINH") %>'></asp:TextBox>
                                            <cc1:CalendarExtender ID="CE_TT" runat="server" TargetControlID="txtNgayToTrinh" Format="dd/MM/yyyy" Enabled="true" PopupPosition="left"/>
                                            <cc1:MaskedEditExtender ID="ME__TT" runat="server" TargetControlID="txtNgayToTrinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true"/>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="80px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                    
                                </Columns>
                                <HeaderStyle CssClass="header"></HeaderStyle>
                                <ItemStyle CssClass="chan"></ItemStyle>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                             <asp:DataGrid ID="gridHS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                ItemStyle-CssClass="chan" Width="100%"
                                OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                <AlternatingItemStyle CssClass="le"></AlternatingItemStyle>
                                <Columns>
                                    <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="30px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Chọn</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:HiddenField ID="hddCurrID" runat="server" Value='<%#Eval("ID")%>' />
                                            <asp:CheckBox ID="chkChon" runat="server" ToolTip='<%#Eval("ID")%>'
                                               AutoPostBack="true" OnCheckedChanged="chkChon_CheckedChanged" />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="30px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="80px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Số & Ngày thụ lý</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("SOTHULYDON")%>
                                            <br />
                                            <%#Eval("NGAYTHULYDON")%>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="80px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                    <asp:TemplateColumn HeaderStyle-Width="100px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Bản án/Quyết định</HeaderTemplate>
                                        <ItemTemplate>
                                            <%#Eval("InforBA")%>
                                            <%--<b><%#Eval("SOANPHUCTHAM")%></b>
                                            <br />
                                            <%#Eval("NGAYXUPHUCTHAM")%>
                                            <br />
                                            <span class='line_space'><%#Eval("TOAXX_VietTat")%></span>--%>
                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Center" Width="100px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                    <asp:BoundColumn DataField="QHPLDN" HeaderText="Tội danh"></asp:BoundColumn>

                                    <asp:BoundColumn DataField="NGUYENDON" HeaderText="Bị cáo đầu vụ" HeaderStyle-Width="120px">
                                        <HeaderStyle Width="120px"></HeaderStyle>
                                    </asp:BoundColumn>
                                    <asp:BoundColumn DataField="BIDON" HeaderText="Bị cáo khiếu nại" HeaderStyle-Width="120px">
                                        <HeaderStyle Width="120px"></HeaderStyle>
                                    </asp:BoundColumn>
                                   <asp:BoundColumn DataField="NGUOIKHIEUNAI" HeaderText="Người khiếu nại" HeaderStyle-Width="120px">
                                        <HeaderStyle Width="120px"></HeaderStyle>
                                    </asp:BoundColumn>

                                     <%--<asp:BoundColumn DataField="TENTHAMPHAN"  HeaderText="Thẩm phán" HeaderStyle-Width="90px"></asp:BoundColumn>--%>
                                    <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                        <HeaderTemplate>Ngày phân công TP</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtNgayPhanCongTP" runat="server" CssClass="user" Width="80px"  
                                                MaxLength="10" placeholder="..../..../....." Text='<%#Eval("NGAYPHANCONGTP") %>'></asp:TextBox>
                                            <cc1:CalendarExtender ID="CE_PCTP" runat="server" TargetControlID="txtNgayPhanCongTP" Format="dd/MM/yyyy" Enabled="true"/>
                                            <cc1:MaskedEditExtender ID="ME__PCTP" runat="server" TargetControlID="txtNgayPhanCongTP" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                            <asp:HiddenField ID="hddISVKS_KN" runat="server" Value='<%#Eval("IsVienTruongKN")%>' />
                                            <asp:HiddenField ID="hddNGAYTP" runat="server" Value='<%#Eval("NGAYPHANCONGTP") %>' />
                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Center" Width="80px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                   
                                    <asp:TemplateColumn HeaderStyle-Width="150px" ItemStyle-HorizontalAlign="Left" HeaderStyle-HorizontalAlign="Center">
                                        <HeaderTemplate>Thẩm phán</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:Literal ID="lttTP" runat="server" Text='<%#Eval("THAMPHANID") %>'></asp:Literal>
                                            <asp:DropDownList CssClass="chosen-select" ID="dropThamPhan" runat="server" Width="150px"
                                                AutoPostBack="true" OnSelectedIndexChanged="dropThamPhan_SelectedIndexChanged">
                                            </asp:DropDownList>
                                            <asp:HiddenField ID="hddTPID" runat="server" Value='<%#Eval("THAMPHANID") %>' />
                                          
                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Center" Width="150px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>
                              
                                    <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="150px">
                                        <HeaderTemplate>Lý do thay đổi</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtLyDo" CssClass="user"
                                                runat="server" Width="150px" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Center" Width="150px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>

                                    <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="50px">
                                        <HeaderTemplate>Số tờ trình</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtSoTT" runat="server" Text='<%#Eval("CD_SOTOTRINH") %>' CssClass="user" Width="40px" MaxLength="250"></asp:TextBox>
                                        </ItemTemplate>

                                        <HeaderStyle HorizontalAlign="Center" Width="50px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                    </asp:TemplateColumn>
                                     <asp:TemplateColumn ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="80px">
                                        <HeaderTemplate>Ngày tờ trình</HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtNgayToTrinh" runat="server" CssClass="user" Width="70px"  
                                                MaxLength="10" placeholder="..../..../....." Text='<%#Eval("CD_NGAYTOTRINH") %>'></asp:TextBox>
                                            <cc1:CalendarExtender ID="CE_TT" runat="server" TargetControlID="txtNgayToTrinh" Format="dd/MM/yyyy" Enabled="true"/>
                                            <cc1:MaskedEditExtender ID="ME__TT" runat="server" TargetControlID="txtNgayToTrinh" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" Width="80px"></HeaderStyle>
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:TemplateColumn>
                                    
                                </Columns>
                                <HeaderStyle CssClass="header"></HeaderStyle>
                                <ItemStyle CssClass="chan"></ItemStyle>
                                <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                            </asp:DataGrid>
                            <div class="phantrang">
                                <div class="sobanghi">
                                </div>
                                <div class="sotrang">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                    &nbsp;&nbsp;
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
    </script>
    <script type="text/javascript">
        function pageLoad(sender, args) {

            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
